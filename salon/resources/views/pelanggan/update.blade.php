@extends('layouts.mainlayout');

@section('title', 'Pelanggan');

@section('content')
    <div class="container mx-auto">
        <h1 class="text-2xl font-bold mb-4">Edit Pelanggan</h1>

        <form action="{{ url('/pelanggan/update', $pelanggan['id']) }}" method="PATCH">
            @csrf
            @method('PATCH')

            <div class="mb-4">
                <label for="nama" class="block text-gray-700 text-sm font-bold mb-2">Nama</label>
                <input type="text" name="nama" id="nama" class="border border-gray-300 rounded py-2 px-4" value="{{ $pelanggan['nama'] }}" required>
            </div>

            <div class="mb-4">
                <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email</label>
                <input type="text" name="email" id="email" class="border border-gray-300 rounded py-2 px-4" value="{{ $pelanggan['email'] }}" required>
            </div>

            <div class="mb-4">
                <label for="nomor_telepon" class="block text-gray-700 text-sm font-bold mb-2">Nomor Telepon</label>
                <input type="text" name="nomor_telepon" id="nomor_telepon" class="border border-gray-300 rounded py-2 px-4" value="{{ $pelanggan['nomor_telepon'] }}" required>
            </div>
            <div class="mb-4">
                <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Save</button>
                <a href="{{ url('/pelanggan/select') }}" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-2 px-4 rounded">Cancel</a>
            </div>
        </form>
    </div>
@endsection
