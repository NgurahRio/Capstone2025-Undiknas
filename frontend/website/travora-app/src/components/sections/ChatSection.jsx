import React from 'react';
import { MessageCircle } from 'lucide-react';

export default function ChatSection() {
    return (
        <div className="bg-[#F2F7FB] -mx-6 lg:-mx-20 px-6 lg:px-20 py-24 rounded-[40px] flex flex-col lg:flex-row gap-16 items-center">
            <div className="lg:w-1/2 space-y-8">
                <h2 className="text-5xl font-bold text-gray-900 leading-tight">Need quick answers?</h2>
                <p className="text-xl text-gray-600 leading-relaxed font-light">Meet Travora’s smart WhatsApp assistant — your travel buddy for instant answers.</p>
                <button className="bg-[#64829F] text-white px-10 py-5 rounded-2xl flex items-center gap-4 font-bold text-xl hover:bg-[#526a86] transition shadow-xl shadow-gray-300">
                    <MessageCircle size={28} /> Start Chat
                </button>
            </div>
            <div className="lg:w-1/2 w-full bg-white rounded-[32px] shadow-2xl overflow-hidden border border-gray-100 flex flex-col h-[500px]">
                <div className="bg-[#64829F] p-6 flex items-center gap-4 text-white">
                    <div className="bg-white/20 p-2 rounded-full"><MessageCircle size={28} /></div>
                    <span className="font-bold text-2xl">Travora Assistant</span>
                </div>
                <div className="flex-1 p-8 overflow-y-auto space-y-6 bg-gray-50/50">
                    <div className="bg-white border border-gray-100 p-5 rounded-2xl rounded-bl-sm mr-auto max-w-[85%] shadow-sm text-gray-700">Halo! Saya Asisten Chat. Mau cari apa?</div>
                    <div className="bg-[#82B1FF] text-white p-5 rounded-2xl rounded-br-sm ml-auto max-w-[85%] shadow-sm">Wisata terpopuler di Ubud</div>
                </div>
                <div className="p-6 border-t bg-white flex gap-4">
                    <input type="text" placeholder="Ketik..." className="flex-1 bg-gray-100 px-6 py-4 rounded-xl outline-none" />
                </div>
            </div>
        </div>
    );
}