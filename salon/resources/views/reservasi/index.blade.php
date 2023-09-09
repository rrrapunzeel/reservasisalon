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
                    <th scope="col">Nama</th>
                    <th scope="col">Pegawai</th>
                    <th scope="col">Perawatan</th>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Jam</th>
                    <th scope="col">Status</th>
                    <th scope="col">Aksi</th>
                </tr>
            </thead>
            <tbody>
                @forelse($reservasis as $item)
                <tr>
                    <th scope="row">{{ $loop->iteration }}</th>
                    <td>{{ $item['nama'] }}</td>
                    <td>{{ $item['pegawai'] }}</td>
                    <td>
    @if (isset($item['items']) && is_array($item['items']))
        <ul>
            @foreach ($item['items'] as $perawatan)
                @if (isset($perawatan['name']))
                    <li>{{ $perawatan['name'] }}</li>
                @endif
            @endforeach
        </ul>
    @else
        Tidak ada item yang tersedia.
    @endif
</td>


                    <td>{{ $item['tanggal'] }}</td>
                    <td>{{ $item['jam'] }}</td>
                    <td>
                    @if ($item['transaction_status'] === 'Berhasil')
    <span class="badge bg-primary">{{ $item['transaction_status'] }}</span>
@elseif ($item['transaction_status'] === 'Lunas')
    <span class="badge bg-success">{{ $item['transaction_status'] }}</span>
                        @elseif ($item['transaction_status'] === 'Tertunda')
                            <span class="badge bg-warning">{{ $item['transaction_status'] }}</span>
                        @elseif ($item['transaction_status'] === 'Gagal')
                            <span class="badge bg-danger">{{ $item['transaction_status'] }}</span>
                        @else
                            <span class="badge">{{ $item['transaction_status'] }}</span>
                        @endif
                    </td>
                    <td>
                        <a href="{{ route('reservasi.update', $item['id']) }}" class="btn btn-outline-primary"><i class="bi bi-pencil-fill"></i></a>
                        <form action="{{ route('reservasi.delete', $item['id']) }}" method="POST" class="d-inline">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus data reservasi ini?')"><i class="bi bi-trash-fill"></i></button>
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
