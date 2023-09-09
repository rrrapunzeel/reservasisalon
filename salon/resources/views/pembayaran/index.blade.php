@extends('layouts.mainlayout')

@section('title', 'Pembayaran')

@section('content')

<div class="pagetitle">
    <h1>Pembayaran</h1>
    <nav>
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="{{ route('dashboard.view') }}">Dashboard</a></li>
            <li class="breadcrumb-item">Pembayaran</li>
        </ol>
    </nav>
</div>
<div class="card">
    <div class="card-body">
        <h5 class="card-title">Data Pembayaran</h5>

        <!-- Table with stripped rows -->

        <table class="table table-borderless datatable">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Nama</th>
                    <th scope="col">Perawatan</th>
                    <th scope="col">Harga DP</th>
                    <th scope="col">Metode Pelunasan</th>
                    <th scope="col">Status</th>
                    <th scope="col">Aksi</th>
                </tr>
            </thead>
            <tbody>
                @forelse($pembayarans as $pembayaran)
                <tr>
                    <th scope="row">{{ $loop->iteration }}</th>
                    <td>{{ $pembayaran['nama'] }}</td>
                    <td>
                        @if (isset($pembayaran['items']) && is_array($pembayaran['items']))
                            <ul>
                                @foreach ($pembayaran['items'] as $item)
                                @if (isset($item['name']))
                    <li>{{ $item['name'] }}</li>
                @endif
                                @endforeach
                            </ul>
                        @else
                            Tidak ada item yang tersedia.
                        @endif
                    </td>
                    <td>{{ $pembayaran['total'] }}</td>
                    <td>{{ $pembayaran['metode_pelunasan'] }}</td>
                    <td>
                    @if ($pembayaran['transaction_status'] === 'Berhasil')
    <span class="badge bg-primary">{{ $pembayaran['transaction_status'] }}</span>
@elseif ($pembayaran['transaction_status'] === 'Lunas')
    <span class="badge bg-success">{{ $pembayaran['transaction_status'] }}</span>
                        @elseif ($pembayaran['transaction_status'] === 'Tertunda')
                            <span class="badge bg-warning">{{ $pembayaran['transaction_status'] }}</span>
                        @elseif ($pembayaran['transaction_status'] === 'Gagal')
                            <span class="badge bg-danger">{{ $pembayaran['transaction_status'] }}</span>
                        @else
                            <span class="badge">{{ $pembayaran['transaction_status'] }}</span>
                        @endif
                    </td>
                    <td>
                        <a href="{{ route('pembayaran.update', $pembayaran['id']) }}" class="btn btn-outline-primary"><i class="bi bi-pencil-fill"></i></a>
                        <form action="{{ route('pembayaran.delete', $pembayaran['id']) }}" method="POST" class="d-inline">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus pembayaran ini?')"><i class="bi bi-trash-fill"></i></button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="7">Tidak ada data pembayaran.</td>
                </tr>
                @endforelse
            </tbody>
        </table>
        <!-- End Table with stripped rows -->
    </div>
</div>
@endsection
