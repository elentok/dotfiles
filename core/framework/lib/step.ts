export type StepItems = Array<StepResult | StepMessage>

export interface Step {
  name: string
  description?: string
}

export type StepStatus = "success" | "silent-success" | "error"

export interface StepResult {
  step: Step
  status: StepStatus
  items: StepItems
  isDebug?: boolean
}

export interface StepMessage {
  type: "debug" | "info" | "success" | "silent-success" | "error" | "warning"
  message: string
}

export function failStep(step: Step, items: StepItems): StepResult {
  return { step, status: "error", items }
}

export function passStep(step: Step, items: StepItems): StepResult {
  return { step, status: "success", items }
}
