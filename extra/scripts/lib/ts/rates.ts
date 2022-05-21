import axios from "axios";
import * as fs from "fs";
import * as os from "os";
import * as path from "path";
import { getConfigOrAsk } from "./dotconfig";

const CACHE_FILE = path.join(os.homedir(), ".cache", "openex.json");
const CACHE_MAX_AGE_IN_HOURS = 12;

const MAPPINGS: { [key: string]: string } = {
  $: "USD",
  NIS: "ILS",
};

const DEFAULTS = ["ILS", "USD"];

interface IRatesData {
  rates: { [key: string]: number };
}

export interface IMoney {
  value: number;
  currency: string;
}

export class Rates {
  constructor(private data: IRatesData) {}

  public convert(from: IMoney, toCurrency?: string): IMoney | undefined {
    const fromCurrency = this.normalize(from.currency);
    if (fromCurrency == null) return;

    toCurrency = this.normalize(toCurrency) || this.getDefaultTo(fromCurrency);
    if (toCurrency == null) return;

    const fromRate = this.data.rates[fromCurrency];
    const toRate = this.data.rates[toCurrency];

    return {
      value: (from.value * toRate) / fromRate,
      currency: toCurrency,
    };
  }

  private getDefaultTo(from: string): string {
    for (let i = 0; i < DEFAULTS.length; i++) {
      if (DEFAULTS[i] !== from) {
        return DEFAULTS[i];
      }
    }

    throw new Error("Can't find default target currency");
  }

  private normalize(currency?: string): string | undefined {
    if (currency == null) return;

    currency = currency.toUpperCase();
    currency = MAPPINGS[currency] || currency;
    if (this.data.rates[currency] == null) {
      throw new Error(`Invalid currency '${currency}'`);
    }

    return currency;
  }
}

let rates: Rates;

export async function convert(from: IMoney, toCurrency: string): Promise<IMoney | undefined> {
  return (await getRates()).convert(from, toCurrency);
}

export async function getRates(): Promise<Rates> {
  if (rates == null) {
    rates = getCachedRates() || (await fetchRates());
  }

  return rates;
}

function getCachedRates(): Rates | undefined {
  if (!isCacheFresh()) return;

  return new Rates(JSON.parse(fs.readFileSync(CACHE_FILE).toString()));
}

function isCacheFresh(): boolean {
  let stat: fs.Stats;

  try {
    stat = fs.statSync(CACHE_FILE);
  } catch (e) {
    return false;
  }

  const ageInMilliseconds = Date.now() - stat.mtime.getTime();
  const ageInHours = ageInMilliseconds / 1000 / 60 / 60;
  return ageInHours < CACHE_MAX_AGE_IN_HOURS;
}

async function fetchRates(): Promise<Rates> {
  const appId = await getOpenExchangeAppId();
  const url = `https://openexchangerates.org/api/latest.json?app_id=${appId}`;
  return axios.get(url).then((response) => {
    fs.writeFileSync(CACHE_FILE, JSON.stringify(response.data, null, 2));
    return new Rates(response.data);
  });
}

export async function getOpenExchangeAppId(): Promise<string> {
  const id = await getConfigOrAsk("open_exchange_app_id", "OpenExchange app id? ");
  if (id == null) throw new Error("Missing OpenExchange App ID");
  return id;
}
