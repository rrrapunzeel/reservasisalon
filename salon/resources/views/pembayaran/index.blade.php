@extends('layouts.mainlayout')

@section('title', 'Pembayaran')

@section('content')

<div class="pagetitle">
<h1>Pembayaran</h1>
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="{{ route ('dashboard.view')}}">Dashboard</a></li>
        <li class="breadcrumb-item">Pembayaran</li>
      </ol>
    </nav>
</div>
<div class="card">
    <div class="card-body">
        <h5 class="card-title">Data Pembayaran</h5>
        <a href="{{ route('pembayaran.create') }}" class="btn btn-primary mb-3">Tambah Pembayaran</a>

        <!-- Table with stripped rows -->

        <table class="table table-borderless datatable">
                <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">ID Pembayaran</th>
                        <th scope="col">Nama</th>
                        <th scope="col">Perawatan</th>
                        <th scope="col">Total</th>
                        <th scope="col">Status</th>
                        <th scope="col">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($pembayarans as $pembayaran)
                    @if (!empty($pembayaran['transaction_id']))
                    <tr>
                        <th scope="row">{{ $loop->iteration }}</th>
                        <td>{{ $pembayaran['transaction_id'] }}</td>
                        <td>{{ $pembayaran['nama'] }}</td>
                        <td>
                        @if (isset($pembayaran['items']) && is_array($pembayaran['items']))
                          <ul>
                              @foreach ($pembayaran['items'] as $item)
                                  <li>{{ $item['name'] }}</li>
                              @endforeach
                          </ul>
                      @else
                          Tidak ada item yang tersedia.
                      @endif
                        </td>
                        <td>{{ $pembayaran['total'] }}</td>
                        <td>{{ $pembayaran['transaction_status'] }}</td>

                        <td>
                            <a href="{{ route('pembayaran.update', ['id' => $pembayaran['transaction_id']]) }}" class="btn btn-outline-primary"><i class="bi bi-pencil-fill"></i></a>

                            <form action="{{ route('pembayaran.delete', ['id' => $pembayaran['transaction_id']]) }}" method="POST" class="d-inline">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus perawatan ini?')"><i class="bi bi-trash-fill"></i></button>
                            </form>
                        </td>
                    </tr>
                    @endif
                    @empty
                    <tr>
                        <td colspan="7">Tidak ada data pembayaran.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        <!-- End Table with stripped rows -->
    </div>
</div>
@endsection
