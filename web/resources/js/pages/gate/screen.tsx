import { Head } from '@inertiajs/react';
import { Check, Contact, X } from 'lucide-react';
import { usePoll } from '@/hooks/use-poll';
import type { ScreenState } from '@/lib/gate-api';
import React, {memo, useState, useEffect} from 'react';

const GREEN = '#2B8132';
const RED = '#C52F37';

const TINT: Record<ScreenState['screen'], string> = {
    idle: 'bg-black/55',
    scanning: 'bg-black/50',
    welcome: 'bg-[#2B8132]/55',
    visitor_welcome: 'bg-[#2B8132]/55',
    flagged: 'bg-[#C52F37]/55',
};

// gate token
const gate_token = import.meta.env.VITE_GATE_TOKEN;

// debugging reset frame button
const resetFrameHandler = async () => {
    try {
        await fetch(`http://localhost:8001/reset_frame?token=${gate_token}`)
        console.log("Frame reset")
    } catch (error) {
        console.error("Error resetting frame:", error)
    }
}

// debugging scan id button
const scanIDHandler = async () => {
    const token = import.meta.env.VITE_GATE_TOKEN;

    try {
        await fetch(`http://localhost:8001/id_scanned?token=${gate_token}`)
        console.log("Scanned ID")
    } catch (error) {
        console.error("Error scanning ID:", error)
    }
}

const WebcamBackground = memo(() => {
    const [streamUrl, setStreamUrl] = useState<string | null>(null);
    const token = import.meta.env.VITE_GATE_TOKEN;

    useEffect(() => {
        setStreamUrl(`http://localhost:8001/video_feed?t=${Date.now()}&token=${gate_token}`)
    }, []);

    if (!streamUrl) {
        return <div className='absolute inset-0 w-full h-full bg-black z-0'></div>
    }
    return (
        <img
            src={streamUrl}
            alt='Student-facing Monitor Cam'
            className='absolute inset-0 w-full h-full object-cover z-0'
        />
    );
}, () => true)

function Badge({ color, children }: { color: string; children: React.ReactNode }) {
    return (
        <div
            className="flex h-[16vw] w-[16vw] items-center justify-center rounded-full"
            style={{ backgroundColor: color }}
        >
            {children}
        </div>
    );
}

export default function GateScreen() {
    const { data } = usePoll<ScreenState>('/gate/screen-state', 500);
    const s: ScreenState = data ?? { screen: 'idle', given_names: null, time: null };
    const showTime = s.screen === 'welcome' || s.screen === 'visitor_welcome';

    return (
        <div className="relative flex h-screen w-screen select-none flex-col items-center overflow-hidden bg-gradient-to-b from-neutral-600 to-neutral-900 text-white">
            <Head title="VerifiGATE" />
            {/* uniform camera */}
            <WebcamBackground />
            
            <div className={`absolute inset-0 transition-colors duration-300 ${TINT[s.screen]}`} />
            {s.screen === 'scanning' && (
                <div className="absolute inset-x-0 bottom-0 h-1/4 bg-gradient-to-t from-[#2B8132] to-transparent" />
            )}

            <header className="relative z-10 mt-[4vh] text-center">
                <div className="text-[9vw] leading-none">
                    <span className="font-light">Verifi</span>
                    <span className="font-extrabold">GATE</span>
                </div>
                <p className="mt-[1vh] text-[2.3vw] leading-tight">
                    School Gate and Ticketless Event Verification
                    <br />
                    with Uniform Checker System
                </p>
            </header>

            <main className="relative z-10 flex flex-1 flex-col items-center justify-center gap-[5vh] text-center">
                {s.screen === 'idle' && (
                    <>
                        <h1 className="text-[7vw] font-bold">Please present your ID</h1>
                        <p className="text-[4vw]">Hold it up to the scanner</p>
                        <Contact className="h-[16vw] w-[16vw] animate-pulse" strokeWidth={1.5} />
                    </>
                )}
                {s.screen === 'scanning' && (
                    <>
                        <h1 className="text-[7vw] font-bold">Scanning and verifying...</h1>
                        <Contact className="h-[16vw] w-[16vw]" strokeWidth={1.5} />
                    </>
                )}
                {s.screen === 'welcome' && (
                    <>
                        <h1 className="text-[7vw] font-light">
                            Welcome, <span className="font-extrabold">{s.given_names}</span>!
                        </h1>
                        <Badge color={GREEN}>
                            <Check className="h-[9vw] w-[9vw]" strokeWidth={3} />
                        </Badge>
                    </>
                )}
                {s.screen === 'visitor_welcome' && (
                    <>
                        <h1 className="text-[7vw] font-light">Welcome, visitor!</h1>
                        <Badge color={GREEN}>
                            <Check className="h-[9vw] w-[9vw]" strokeWidth={3} />
                        </Badge>
                    </>
                )}
                {s.screen === 'flagged' && (
                    <>
                        <div>
                            <h1 className="text-[8vw] font-extrabold">Flagged</h1>
                            <p className="mt-[1vh] text-[6vw] font-light">Please step aside.</p>
                        </div>
                        <Badge color={RED}>
                            <X className="h-[9vw] w-[9vw]" strokeWidth={3} />
                        </Badge>
                    </>
                )}
                {/* debugging reset frame */}
                <button
                    onClick={resetFrameHandler}
                    className='bg-white text-black'
                >
                    Reset Frame
                </button>
                <button
                    onClick={scanIDHandler}
                    className='bg-white text-black'
                >
                    Scan ID Demo
                </button>
            </main>

            <footer className="relative z-10 mb-[6vh] h-[12vh] text-center">
                {showTime && s.time && (
                    <>
                        <div className="text-[5vw] font-bold">Time logged:</div>
                        <div className="text-[6vw] font-light">{s.time}</div>
                    </>
                )}
            </footer>

        </div>
    );
}
