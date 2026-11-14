import React, {memo, useState, useEffect} from 'react';

const WebcamBackground = memo(() => {
    const gate_token = import.meta.env.VITE_GATE_TOKEN;
    
    const [streamUrl, setStreamUrl] = useState<string | null>(null);
    const token = import.meta.env.VITE_GATE_TOKEN;

    useEffect(() => {
        setStreamUrl(`http://localhost:8002/video_feed?t=${Date.now()}&token=${gate_token}`)
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

export default WebcamBackground