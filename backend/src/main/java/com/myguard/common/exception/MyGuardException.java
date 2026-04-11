package com.myguard.common.exception;

public class MyGuardException extends RuntimeException {

    public MyGuardException(String message) {
        super(message);
    }

    public MyGuardException(String message, Throwable cause) {
        super(message, cause);
    }
}
