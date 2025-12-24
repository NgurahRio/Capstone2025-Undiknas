import React from 'react';
import EventSection from '../components/sections/EventSection';

export default function Events() {
  return (
    <div className="flex flex-col gap-12">
      <div className="w-full h-56 bg-gradient-to-r from-[#5E9BF5] to-[#9AC7FF] text-white flex items-center">
        <div className="max-w-7xl w-full mx-auto px-6">
          <p className="text-sm font-semibold uppercase tracking-widest opacity-90 mb-2">Travora</p>
          <h1 className="text-4xl font-bold">Events</h1>
          <p className="text-sm md:text-base opacity-90 max-w-2xl">
            Discover the latest events at your favorite destinations and get all the details you need.
          </p>
        </div>
      </div>

      <div className="max-w-7xl w-full mx-auto px-6 pb-16">
        <EventSection />
      </div>
    </div>
  );
}
