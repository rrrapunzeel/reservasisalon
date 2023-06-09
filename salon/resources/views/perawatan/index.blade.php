<!-- resources/views/perawatan/index.blade.php -->

@extends('layouts.app')

@section('content')
    <div class="container mx-auto">
        <h1 class="text-2xl font-bold mb-4">Daftar Perawatan</h1>

        <a href="{{ url('/perawatan/create') }}" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded mb-4">Tambah Perawatan</a>

        <table class="border-collapse border border-gray-300">
            <thead>
                <tr>
                    <th class="border border-gray-300 py-2 px-4">ID</th>
                    <th class="border border-gray-300 py-2 px-4">Kategori</th>
                    <th class="border border-gray-300 py-2 px-4">Nama Perawatan</th>
                    <th class="border border-gray-300 py-2 px-4">Harga Perawatan</th>
                    <th class="border border-gray-300 py-2 px-4">Aksi</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($perawatans as $perawatan)
                    <tr>
                        <td class="border border-gray-300 py-2 px-4">{{ $perawatan->id_perawatan }}</td>
                        <td class="border border-gray-300 py-2 px-4">{{ $perawatan->kategori->nama_kategori }}</td>
                        <td class="border border-gray-300 py-2 px-4">{{ $perawatan->nama_perawatan }}</td>
                        <td class="border border-gray-300 py-2 px-4">{{ $perawatan->harga_perawatan }}</td>
                        <td class="border border-gray-300 py-2 px-4">
                            <a href="{{ url('/perawatan/edit', $perawatan->id_perawatan) }}" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Edit</a>
                            <form action="{{ url('/perawatan/delete', $perawatan->id_perawatan) }}" method="POST" class="inline-block">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">Delete</button>
                            </form>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    </div>
@endsection
