<!-- resources/views/perawatan/edit.blade.php -->

@extends('layouts.app')

@section('content')
    <div class="container mx-auto">
        <h1 class="text-2xl font-bold mb-4">Edit Perawatan</h1>

        <form action="{{ url('/perawatan/update', $perawatan->id_perawatan) }}" method="POST">
            @csrf
            @method('PATCH')

            <div class="mb-4">
                <label for="id_kategori" class="block text-gray-700 text-sm font-bold mb-2">Kategori:</label>
                <select name="id_kategori" id="id_kategori" class="border border-gray-300 rounded py-2 px-4">
                    <!-- Populate options with categories data -->
                    @foreach ($categories as $category)
                        <option value="{{ $category->id_kategori }}" @if ($category->id_kategori === $perawatan->id_kategori) selected @endif>{{ $category->nama_kategori }}</option>
                    @endforeach
                </select>
            </div>

            <div class="mb-4">
                <label for="nama_perawatan" class="block text-gray-700 text-sm font-bold mb-2">Nama Perawatan:</label>
                <input type="text" name="nama_perawatan" id="nama_perawatan" class="border border-gray-300 rounded py-2 px-4" value="{{ $perawatan->nama_perawatan }}" required>
            </div>

            <div class="mb-4">
                <label for="harga_perawatan" class="block text-gray-700 text-sm font-bold mb-2">Harga Perawatan:</label>
                <input type="number" name="harga_perawatan" id="harga_perawatan" class="border border-gray-300 rounded py-2 px-4" value="{{ $perawatan->harga_perawatan }}" required>
            </div>

            <div class="mb-4">
                <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Save</button>
                <a href="{{ url('/perawatan/select') }}" class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-bold py-2 px-4 rounded">Cancel</a>
            </div>
        </form>
    </div>
@endsection
