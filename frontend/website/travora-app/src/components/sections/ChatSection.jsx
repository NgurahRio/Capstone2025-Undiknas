import React from 'react';
import { MessageCircle } from 'lucide-react';

export default function ChatSection() {
    return (
        <div className="bg-[#F2F7FB] -mx-6 lg:-mx-20 px-6 lg:px-20 py-24 rounded-[40px] flex flex-col lg:flex-row gap-16 items-center">
            <div className="lg:w-1/2 space-y-8">
                <h2 className="text-5xl font-bold text-gray-900 leading-tight">Need quick answers?</h2>
                <p className="text-xl text-gray-600 leading-relaxed font-light">🚀 Travora is here for your journey!</p>
                <p className="text-xl text-gray-600 leading-relaxed font-light">A smart WhatsApp assistant that helps you get instant answers, travel recommendations, and practical guidance—just through chat.</p>
            </div>
            <div className="lg:w-1/2 w-full bg-white rounded-[32px] shadow-2xl overflow-hidden border border-gray-100 flex flex-col h-[500px]">
                <div className="bg-[#64829F] p-6 flex items-center gap-4 text-white">
                    <div className="bg-white/20 p-2 rounded-full"><MessageCircle size={28} /></div>
                    <span className="font-bold text-2xl">Travora Assistant</span>
                </div>
                <div className="flex-1 p-8 overflow-y-auto space-y-6 bg-gray-50/50">
                    <div className="bg-white border border-gray-100 p-5 rounded-2xl rounded-bl-sm mr-auto max-w-[85%] shadow-sm text-gray-700">Hello! I’m your Chat Assistant. What are you looking for?</div>
                    <div className="bg-[#82B1FF] text-white p-5 rounded-2xl rounded-br-sm ml-auto max-w-[85%] shadow-sm">What places can I visit in Ubud?</div>
                </div>
                <div className="p-6 border-t bg-white">
                    <button
                      onClick={() => window.open('https://wa.me/6285166189866', '_blank')}
                      className="w-full bg-gradient-to-r from-[#64829F] to-[#7FA6D1] text-white px-6 py-4 rounded-xl font-bold text-lg flex items-center justify-center gap-3 hover:from-[#526a86] hover:to-[#6b8fb7] transition shadow-lg shadow-[#64829F]/30 border border-white/50"
                    >
                        <MessageCircle size={24} /> Start Chat
                    </button>
                </div>
            </div>
        </div>
    );
}
