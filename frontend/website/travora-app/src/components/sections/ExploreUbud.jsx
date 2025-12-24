import React from 'react';

// Tetap memakai layout lama (1 besar kiri, 2 tumpuk tengah, 1 besar kanan)
// tapi semua kartu hanya menampilkan satu gambar dari folder public yang di-split per posisi.
export default function ExploreUbud() {
  const ubudImage = '/IMG_3466.PNG'; // pastikan file ada di folder public

  const slices = [
    { id: 'left-large', position: '0% 50%' },       // kiri besar
    { id: 'center-top', position: '50% 0%' },       // tengah atas
    { id: 'center-bottom', position: '50% 100%' },  // tengah bawah
    { id: 'right-large', position: '100% 50%' },    // kanan besar
  ];

  const UbudCard = ({ position, className }) => (
    <div className={`relative overflow-hidden rounded-3xl shadow-lg ${className} pointer-events-none select-none`}>
      <div
        className="w-full h-full bg-cover bg-center"
        style={{
          backgroundImage: `url(${ubudImage})`,
          backgroundSize: '200% 200%', // zoom supaya tiap kartu menampilkan kuadran berbeda
          backgroundPosition: position,
        }}
      />
      <div className="absolute inset-0 bg-black/10" />
    </div>
  );

  return (
    <div className="bg-[#F2F7FB] -mx-6 lg:-mx-20 px-6 lg:px-20 py-24 rounded-[40px] mt-10">
      <div className="max-w-7xl mx-auto">
        <h2 className="text-4xl font-bold text-center mb-12 text-gray-900">Explore Ubud</h2>

        {/* layout lama */}
        <div className="flex flex-col md:flex-row h-auto md:h-[500px] gap-6">
          {/* KIRI (BESAR) */}
          <div className="flex-1 rounded-3xl overflow-hidden">
            <UbudCard position={slices[0].position} className="w-full h-full" />
          </div>

          {/* TENGAH (2 tumpuk) */}
          <div className="flex-[0.8] flex flex-col gap-6">
            <div className="flex-1 rounded-3xl overflow-hidden">
              <UbudCard position={slices[1].position} className="w-full h-full" />
            </div>
            <div className="flex-1 rounded-3xl overflow-hidden">
              <UbudCard position={slices[2].position} className="w-full h-full" />
            </div>
          </div>

          {/* KANAN (BESAR) */}
          <div className="flex-1 rounded-3xl overflow-hidden">
            <UbudCard position={slices[3].position} className="w-full h-full" />
          </div>
        </div>
      </div>
    </div>
  );
}
