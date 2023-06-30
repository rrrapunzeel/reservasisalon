@extends('layouts.mainlayout')

@section('title', 'Reservasi')

@section('content')

<div class="pagetitle">
    <h1>Salon</h1>
    <nav>
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="{{ route('dashboard.view') }}">Dashboard</a></li>
            <li class="breadcrumb-item">Reservasi</li>
        </ol>
    </nav>
</div>
<div class="card">
    <div class="card-body">
        <h5 class="card-title">Data Reservasi</h5>
        <a href="{{ route('reservasi.create') }}" class="btn btn-primary mb-3">Tambah Reservasi</a>

        <!-- Table with stripped rows -->
        <table class="table table-borderless datatable">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">ID Reservasi</th>
                    <th scope="col">Nama</th>
                    <th scope="col">Pegawai</th>
                    <th scope="col">Perawatan</th>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Jam</th>
                    <th scope="col">Aksi</th>
                </tr>
            </thead>
            <tbody>
                @forelse($reservasi as $item)
                <tr>
                    <th scope="row">{{ $loop->iteration }}</th>
                    <td>{{ $item['id_reservasi'] }}</td>
                    <td>{{ $item['nama'] }}</td>
                    <td>{{ $item['id_pegawai'] }}</td>
                    <td>
                        @if (isset($item['items']) && is_array($item['items']))
                        <ul>
                            @foreach ($item['items'] as $perawatan)
                            <li>{{ $perawatan['item_perawatan'] }}</li>
                            @endforeach
                        </ul>
                        @else
                        Tidak ada perawatan yang tersedia.
                        @endif
                    </td>
                    <td>{{ $item['date'] }}</td>
                    <td>{{ $item['jam_perawatan'] }}</td>
                    <td>
                        <a href="{{ route('reservasi.update', $item['id_reservasi']) }}" class="btn btn-outline-primary"><i class="bi bi-pencil-fill"></i></a>
                        <form action="{{ route('reservasi.delete', $item['id_reservasi']) }}" method="POST" class="d-inline">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus perawatan ini?')">Hapus</button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="8">Tidak ada data reservasi.</td>
                </tr>
                @endforelse
            </tbody>
        </table>
        <!-- End Table with stripped rows -->

    </div>
</div>

@endsection
