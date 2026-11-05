<?php

namespace App\Enums\Gate;

enum FlagReason: string
{
    case LowOcrConfidence = 'low_ocr_confidence';
    case NoMatch = 'no_match';
    case NameMismatch = 'name_mismatch';
    case MatchedByNameOnly = 'matched_by_name_only';
    case AmbiguousMatch = 'ambiguous_match';
    case InactiveStudent = 'inactive_student';
    case AlreadyInside = 'already_inside';
    case NotInside = 'not_inside';
    case UniformNonCompliant = 'uniform_non_compliant';
    case UniformLowConfidence = 'uniform_low_confidence';
    case UniformUnavailable = 'uniform_unavailable';
    case OcrUnavailable = 'ocr_unavailable';
    case UnreadableAfterRetry = 'unreadable_after_retry';
    case VisitorReview = 'visitor_review';
    case GuardManualFlag = 'guard_manual_flag';

    /** @return list<self> */
    public static function uniformReasons(): array
    {
        return [self::UniformNonCompliant, self::UniformLowConfidence, self::UniformUnavailable];
    }

    public function label(): string
    {
        return match ($this) {
            self::LowOcrConfidence => 'Low OCR confidence',
            self::NoMatch => 'ID number not found in records',
            self::NameMismatch => 'Name does not match the record',
            self::MatchedByNameOnly => 'Matched by name only (no readable ID number)',
            self::AmbiguousMatch => 'More than one possible match',
            self::InactiveStudent => 'Not an active record',
            self::AlreadyInside => 'Already inside today',
            self::NotInside => 'Not logged as inside',
            self::UniformNonCompliant => 'Uniform not compliant',
            self::UniformLowConfidence => 'Uniform check: low confidence',
            self::UniformUnavailable => 'Uniform check unavailable',
            self::OcrUnavailable => 'OCR service unavailable',
            self::UnreadableAfterRetry => 'Unreadable after retry',
            self::VisitorReview => 'Visitor: needs guard check',
            self::GuardManualFlag => 'Guard-initiated entry',
        };
    }
}
