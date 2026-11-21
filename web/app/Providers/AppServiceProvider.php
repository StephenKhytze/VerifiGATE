<?php

namespace App\Providers;

use App\Services\IdScan\ConfigUniformProvider;
use App\Services\IdScan\UniformProvider;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\Date;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\ServiceProvider;
use Illuminate\Validation\Rules\Password;
use App\Services\Notifications\MockSmsGateway;
use App\Services\Notifications\SemaphoreSmsGateway;
use App\Services\Notifications\SmsGateway;
use InvalidArgumentException;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
    */
    public function register(): void
    {
        $this->app->bind(UniformProvider::class, ConfigUniformProvider::class);
        $this->app->bind(SmsGateway::class, fn ($app) => match (config('verifigate.notifications.driver')) {
            'mock' => $app->make(MockSmsGateway::class),
            'semaphore' => $app->make(SemaphoreSmsGateway::class),
            default => throw new InvalidArgumentException(
                'Unsupported NOTIFY_DRIVER: ' . config('verifigate.notifications.driver')
            ),
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        $this->configureDefaults();
    }

    /**
     * Configure default behaviors for production-ready applications.
     */
    protected function configureDefaults(): void
    {
        Date::use(CarbonImmutable::class);

        DB::prohibitDestructiveCommands(
            app()->isProduction(),
        );

        Password::defaults(fn (): ?Password => app()->isProduction()
            ? Password::min(12)
                ->mixedCase()
                ->letters()
                ->numbers()
                ->symbols()
                ->uncompromised()
            : null,
        );
    }
}
