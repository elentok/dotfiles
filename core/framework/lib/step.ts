export type StepItems = Array<StepResult | StepMessage>

export interface Step {
  name: string
  description?: string
}

export interface StepResult {
  step: Step
  isSuccess: boolean
  items: StepItems
}

export interface StepMessage {
  type: "debug" | "info" | "success" | "silent-sucess" | "error" | "warning"
  message: string
}

export function failStep(step: Step, items: StepItems): StepResult {
  return { step, isSuccess: false, items }
}

export function passStep(step: Step, items: StepItems): StepResult {
  return { step, isSuccess: true, items }
}

export function wrapResult(
  step: Step,
  childResult: StepResult,
  items: StepItems,
): StepResult {
  return { step, isSuccess: true, items }
}
