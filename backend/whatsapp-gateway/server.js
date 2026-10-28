// Local WhatsApp Web (QR) gateway for the Laravel backend. Bind to localhost only.
// Env: WA_GATEWAY_SECRET (required), WA_GATEWAY_PORT (3100), WA_AUTH_DIR (./auth)
import http from 'node:http';
import { rm } from 'node:fs/promises';
import pino from 'pino';
import QRCode from 'qrcode';
import * as baileys from '@whiskeysockets/baileys';
const makeWASocket = baileys.default?.default ?? baileys.default ?? baileys.makeWASocket;
const { useMultiFileAuthState, DisconnectReason, fetchLatestBaileysVersion, Browsers } = baileys;

const SECRET = process.env.WA_GATEWAY_SECRET;
const PORT = Number(process.env.WA_GATEWAY_PORT || 3100);
const AUTH_DIR = process.env.WA_AUTH_DIR || './auth';
if (!SECRET) { console.error('WA_GATEWAY_SECRET is required'); process.exit(1); }

const logger = pino({ level: 'warn' });
let sock = null;
let state = { status: 'disconnected', qr: null, number: null, name: null, error: null };
let wantConnected = true;
let sendChain = Promise.resolve();

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const rand = (min, max) => Math.floor(min + Math.random() * (max - min + 1));

async function start() {
  const { state: auth, saveCreds } = await useMultiFileAuthState(AUTH_DIR);
  const { version } = await fetchLatestBaileysVersion();
  state = { ...state, status: 'connecting', error: null };
  sock = makeWASocket({ version, auth, logger, browser: Browsers.appropriate('TireMax'), markOnlineOnConnect: false, syncFullHistory: false });
  sock.ev.on('creds.update', saveCreds);
  sock.ev.on('connection.update', async (u) => {
    if (u.qr) state = { ...state, status: 'qr', qr: await QRCode.toDataURL(u.qr, { margin: 1, width: 320 }) };
    if (u.connection === 'open') {
      const id = sock.user?.id?.split(':')[0]?.split('@')[0] ?? null;
      state = { status: 'connected', qr: null, number: id, name: sock.user?.name ?? null, error: null };
    }
    if (u.connection === 'close') {
      const code = u.lastDisconnect?.error?.output?.statusCode;
      sock = null;
      if (code === DisconnectReason.loggedOut) {
        await rm(AUTH_DIR, { recursive: true, force: true });
        state = { status: 'disconnected', qr: null, number: null, name: null, error: 'logged_out' };
        if (wantConnected) setTimeout(start, 1000);
      } else {
        state = { ...state, status: 'connecting', qr: null };
        if (wantConnected) setTimeout(start, 3000);
      }
    }
  });
}

// Messages are sent one at a time with a human-like typing pause and random gap (anti-ban).
function enqueueSend(to, text, minGap, maxGap) {
  const job = sendChain.then(async () => {
    if (state.status !== 'connected' || !sock) throw new Error('not_connected');
    const jid = `${String(to).replace(/\D/g, '')}@s.whatsapp.net`;
    const [exists] = await sock.onWhatsApp(jid);
    if (!exists?.exists) throw new Error('number_not_on_whatsapp');
    await sock.presenceSubscribe(jid);
    await sock.sendPresenceUpdate('composing', jid);
    await sleep(Math.min(6000, 800 + text.length * 25));
    await sock.sendPresenceUpdate('paused', jid);
    const res = await sock.sendMessage(jid, { text });
    await sleep(rand(minGap, maxGap));
    return { id: res?.key?.id ?? null };
  });
  sendChain = job.catch(() => {});
  return job;
}

const body = (req) => new Promise((resolve) => {
  let d = ''; req.on('data', (c) => (d += c)); req.on('end', () => { try { resolve(JSON.parse(d || '{}')); } catch { resolve({}); } });
});
const json = (res, code, obj) => { res.writeHead(code, { 'content-type': 'application/json' }); res.end(JSON.stringify(obj)); };

http.createServer(async (req, res) => {
  if (req.headers['x-gateway-secret'] !== SECRET) return json(res, 401, { error: 'unauthorized' });
  try {
    if (req.method === 'GET' && req.url === '/status') return json(res, 200, state);
    if (req.method === 'POST' && req.url === '/connect') {
      wantConnected = true;
      if (!sock && state.status !== 'connecting') start();
      return json(res, 200, { ok: true });
    }
    if (req.method === 'POST' && req.url === '/logout') {
      wantConnected = false;
      try { await sock?.logout(); } catch {}
      sock = null;
      await rm(AUTH_DIR, { recursive: true, force: true });
      state = { status: 'disconnected', qr: null, number: null, name: null, error: null };
      return json(res, 200, { ok: true });
    }
    if (req.method === 'POST' && req.url === '/send') {
      const { to, message, min_gap_ms = 3000, max_gap_ms = 8000 } = await body(req);
      if (!to || !message) return json(res, 422, { error: 'to and message required' });
      try { return json(res, 200, await enqueueSend(to, String(message), min_gap_ms, max_gap_ms)); }
      catch (e) { return json(res, e.message === 'not_connected' ? 409 : 422, { error: e.message }); }
    }
    json(res, 404, { error: 'not_found' });
  } catch (e) { json(res, 500, { error: e.message }); }
}).listen(PORT, '127.0.0.1', () => console.log(`WhatsApp gateway on 127.0.0.1:${PORT}`));

start();
