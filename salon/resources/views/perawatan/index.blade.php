@extends('layouts.mainlayout')

@section('title', 'Perawatan')

@section('content')

<div class="pagetitle">
    <h1>Perawatan</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="{{ route ('dashboard.view')}}">Dashboard</a></li>
        <li class="breadcrumb-item">Perawatan</li>
      </ol>
    </nav>
</div>
<div class="card">
    <div class="card-body">
        <h5 class="card-title">Data Perawatan</h5>
        <a href="{{ route('perawatan.create') }}" class="btn btn-primary mb-3">Tambah Perawatan</a>

        <div class="table-responsive">
        <!-- Table with stripped rows -->
        <table class="table table-borderless datatable">
            
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Kategori</th>
                    <th scope="col">Nama Perawatan</th>
                    <th scope="col">Harga</th>
                    <th scope="col">Aksi</th>
                </tr>
            </thead>
            <tbody>
            @foreach($perawatans as $perawatan)
                <tr>
                <th scope="row">{{ $loop->iteration }}</th>
                    <td>
                        @foreach ($kategoris as $kategori)
                            @if ($kategori['id_kategori'] === $perawatan['id_kategori'])
                                {{ $kategori['nama_kategori'] }}
                            @endif
                        @endforeach
                    </td>
                    <td>{{ $perawatan['nama_perawatan'] }}</td>
                    <td>{{ $perawatan['harga_perawatan'] }}</td>
                    <td>
                            <a href="{{ route('perawatan.update', $perawatan['id_perawatan']) }}" class="btn btn-outline-primary"><i class="bi bi-pencil-fill"></i></a>
                            <form action="{{ route('perawatan.delete', $perawatan['id_perawatan']) }}" method="POST" class="d-inline">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus perawatan ini?')"><i class="bi bi-trash-fill"></i></button>
                            </form>
                        </td>
                </tr>
            @endforeach
            </tbody>
        </table>
        <!-- End Table with stripped rows -->

    </div>
</div>
@endsection
