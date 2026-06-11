import { IUserProfile } from "@/types"
import { useState } from "react"

export const useAuth = () => {
    const [user, setUser] = useState<IUserProfile | null>(null)
    const [isLogged, setIsLogged] = useState<boolean>(false)
    return { user, isLogged }
}