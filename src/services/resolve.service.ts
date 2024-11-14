// Créditos: https://dev.to/mpiorowski/typescript-with-gorust-errors-no-trycatch-heresy-49mf

export function resolve<T>(promise: Promise<T>): Promise<Resolve<T>>;
export function resolve<T>(func: () => T): Resolve<T>;
export function resolve<T>(promiseOrFunc: Promise<T> | (() => T)): Promise<Resolve<T>> | Resolve<T> {
  if (promiseOrFunc instanceof Promise) {
    return resolveAsync(promiseOrFunc);
  }
  return resolveSync(promiseOrFunc);
}

export async function resolveAsync<T>(promise: Promise<T>): Promise<Resolve<T>> {
  try {
    const data = await promise;
    return { data, success: true };
  } catch (error) {
    return { success: false, error };
  }
}

export function resolveSync<T>(func: () => T): Resolve<T> {
  try {
    const data = func();
    return { data, success: true };
  } catch (error) {
    return { success: false, error };
  }
}

export type Resolve<T> =
  | {
      success: true;
      data: T;
    }
  | {
      success: false;
      error: unknown;
    };
