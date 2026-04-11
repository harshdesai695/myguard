package com.myguard.common.exception;

public class FirebaseOperationException extends MyGuardException {

    public FirebaseOperationException(String message) {
        super(message);
    }

    public FirebaseOperationException(String message, Throwable cause) {
        super(message, cause);
    }
}
