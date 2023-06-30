@extends('layouts.mainlayout')

@section('title', 'Kategori')

@section('content')
<div class="pagetitle">
    <h1>Kategori</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="{{ route ('dashboard.view')}}">Dashboard</a></li>
        <li class="breadcrumb-item">Kategori</li>
      </ol>
    </nav>
  </div>
        <div class="card">
          <div class="card-body">
            <h5 class="card-title">Data Kategori</h5>
            <a href="{{ route('kategori.create') }}" class="btn btn-primary mb-3">Tambah kategori</a>
            <!-- Table with stripped rows -->
            <table class="table table-borderless datatable">
              <thead>
                <tr>
                  <th scope="col">#</th>
                  <th scope="col">Nama Kategori</th>
                  <th scope="col">Aksi</th>
                </tr>
              </thead>
              <tbody>
                @forelse($kategoris as $kategori)
                  <tr>
                    <th scope="row">{{ $loop->iteration }}</th>
                    <td>{{ $kategori->nama_kategori }}</td>
                    <td>
                      <a href="{{ route('kategori.update', $kategori->id_kategori) }}" class="btn btn-outline-primary"><i class="bi bi-pencil-fill"></i></a>
                      <form action="{{ route('kategori.delete', $kategori->id_kategori) }}" method="POST" class="d-inline">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus perawatan ini?')"><i class="bi bi-trash-fill"></i></button>
                      </form>
                    </td>
                  </tr>
                @empty
                  <tr>
                    <td colspan="3">Tidak ada data kategori.</td>
                  </tr>
                @endforelse
              </tbody>
            </table>
            <!-- End Table with stripped rows -->
          </div>
        </div>

@endsection
