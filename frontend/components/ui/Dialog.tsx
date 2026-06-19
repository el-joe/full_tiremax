"use client";
import React, { ReactNode } from "react";
import {
  Dialog as ChakraDialog,
  CloseButton,
  type DialogRootProviderProps,
  Portal,
} from "@chakra-ui/react";
import useDir from "@/hooks/useDir";

type Props = DialogRootProviderProps & {
  children: ReactNode;
  trigger?: ReactNode;
  dialogTitle?: string;
  closeIconButton?: boolean;
};

export default function Dialog({
  trigger,
  children,
  dialogTitle,
  closeIconButton,
  ...rest
}: Props) {
  const dir = useDir();
  return (
    <ChakraDialog.RootProvider {...rest}>
      {/* {trigger && ( */}
      <ChakraDialog.Trigger asChild dir={dir}>
        {trigger}
      </ChakraDialog.Trigger>
      {/* )} */}
      <Portal>
        <ChakraDialog.Backdrop />
        <ChakraDialog.Positioner>
          <ChakraDialog.Content>
            {dialogTitle ||
              (closeIconButton && (
                <ChakraDialog.Header>
                  {dialogTitle && (
                    <ChakraDialog.Title>{dialogTitle}</ChakraDialog.Title>
                  )}
                </ChakraDialog.Header>
              ))}
            <ChakraDialog.Body>{children}</ChakraDialog.Body>
            {closeIconButton && (
              <ChakraDialog.CloseTrigger asChild>
                <CloseButton size="sm" color={"black"} />
              </ChakraDialog.CloseTrigger>
            )}
          </ChakraDialog.Content>
        </ChakraDialog.Positioner>
      </Portal>
    </ChakraDialog.RootProvider>
  );
}
