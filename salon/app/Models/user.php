<?
namespace App;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable implements MustVerifyEmail
{
    use Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'email', 'password', 'google_id', 'avatar',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    /**
     * Find or create a user based on Google login.
     *
     * @param  string  $googleId
     * @param  string  $name
     * @param  string  $email
     * @param  string|null  $avatar
     * @return User
     */
    public static function findOrCreateGoogleUser($googleId, $name, $email, $avatar = null)
    {
        $user = User::where('google_id', $googleId)->first();

        if ($user) {
            return $user;
        }

        return User::create([
            'google_id' => $googleId,
            'name' => $name,
            'email' => $email,
            'avatar' => $avatar,
        ]);
    }
}
