import { useEffect, useState } from 'react';
import { api, ApiError } from '@/lib/gate-api';

/** Fetches `url` every `interval` ms. Calls never overlap. */
export function usePoll<T>(url: string, interval = 500) {
    const [data, setData] = useState<T | null>(null);
    const [error, setError] = useState(false);

    useEffect(() => {
        let alive = true;
        let timer: number | undefined;

        const tick = async () => {
            try {
                const next = await api<T>(url);
                if (alive) {
                    setData(next);
                    setError(false);
                }
            } catch (e) {
                if (e instanceof ApiError && (e.status === 401 || e.status === 419)) {
                    window.location.reload(); // session expired: go back to the login page
                    return;
                }
                if (alive) setError(true);
            }
            if (alive) timer = window.setTimeout(tick, interval);
        };

        tick();

        return () => {
            alive = false;
            window.clearTimeout(timer);
        };
    }, [url, interval]);

    return { data, error };
}
