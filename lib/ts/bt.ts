export interface IBtOptions {
  host: string
  port: number
}

export class BtClient {
  private options: IBtOptions

  constructor(options: Partial<IBtOptions> = {}) {
    this.options = { host: 'localhost', port: 9091, ...options }
  }
}
