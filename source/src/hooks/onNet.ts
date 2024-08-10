import { MutableRefObject, useEffect, useRef } from "react";
const noop = () => {};

interface NuiMessageData<T> {
  eventName: string;
  payload: T;
}

type NuiHandlerSignature<T> = (payload: T) => void;

export const onNet = <T>(params: {
  eventName: string;
  handler: (payload: T) => void;
}) => {
  const savedHandler: MutableRefObject<NuiHandlerSignature<T>> = useRef(noop);

  useEffect(() => {
    savedHandler.current = params.handler;
  }, [params.handler]);

  useEffect(() => {
    const eventListener = (event: MessageEvent<NuiMessageData<T>>) => {
      const { eventName, payload } = event.data;

      if (savedHandler.current) {
        if (eventName === params.eventName) {
          savedHandler.current(payload);
        }
      }
    };

    window.addEventListener("message", eventListener);
    return () => window.removeEventListener("message", eventListener);
  }, [params.eventName]);
};
