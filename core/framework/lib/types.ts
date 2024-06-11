export interface StepResult {
  isSuccess: boolean
  messages: StepMessage[]
}

export interface StepMessage {
  type: "debug" | "info" | "success" | "silent-sucess" | "error" | "warning"
  message: string
}
