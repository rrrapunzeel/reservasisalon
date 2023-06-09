<!-- resources/views/perawatan/show.blade.php -->

@extends('layouts.app')

@section('content')
    <div class="container mx-auto">
        <h1 class="text-2xl font-bold mb-4">Detail Perawatan</h1>

        <div class="mb-4">
            <p><span class="font-bold">ID:</span> {{ $perawatan->id_perawatan }}</p>
            <p><span class="font-bold">Kategori:</span> {{ $perawatan->kategori->nama_kategori }}</p>
            <p><span class="font-bold">Nama Perawatan:</span> {{ $perawatan->nama_perawatan }}</p>
            <p><span class="font-bold">Harga Perawatan:</span> {{ $perawatan->harga_perawatan }}</p>
        </div>

        <a href="{{ url('/perawatan/select') }}" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-2 px-4 rounded">Back</a>
    </div>
@endsection
