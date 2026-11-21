<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('guardians', function (Blueprint $t) {
            $t->string('mobile_number', 20)->nullable()->after('suffix');
        });

        Schema::table('pickup_authorizations', function (Blueprint $t) {
            $t->boolean('notify_on_entry')->default(false)->after('is_active');
        });

        Schema::table('sms_notifications', function (Blueprint $t) {
            $t->foreignId('guardian_id')->nullable()->after('gate_event_id')
                ->constrained()->nullOnDelete();
            $t->string('recipient_hint')->nullable();   // masked number, e.g. 09*****0001
            $t->string('error', 200)->nullable();       // short code only, no personal data
            $t->timestamp('sent_at')->nullable();
            $t->unique(['gate_event_id', 'guardian_id']);   // one message per guardian per entry
            $t->index(['status', 'created_at']);            // "Important" panel queries
        });
    }

    public function down(): void
    {
        Schema::table('sms_notifications', function (Blueprint $t) {
            // MySQL may use the unique index to back the gate_event_id foreign key,
            // so drop that foreign key first and re-add it below.
            $t->dropForeign(['gate_event_id']);
            $t->dropForeign(['guardian_id']);
            $t->dropUnique(['gate_event_id', 'guardian_id']);
            $t->dropIndex(['status', 'created_at']);
            $t->dropColumn(['guardian_id', 'recipient_hint', 'error', 'sent_at']);
        });

        Schema::table('sms_notifications', function (Blueprint $t) {
            $t->foreign('gate_event_id')->references('id')->on('gate_events')->cascadeOnDelete();
        });

        Schema::table('pickup_authorizations', fn (Blueprint $t) => $t->dropColumn('notify_on_entry'));
        Schema::table('guardians', fn (Blueprint $t) => $t->dropColumn('mobile_number'));
    }
};