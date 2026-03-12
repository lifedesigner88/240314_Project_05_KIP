package com.FINAL.KIP.user;

import java.util.regex.Pattern;

public final class EmployeeIdPolicy {

    public static final String PREFIX = "asm-";
    public static final int ID_WIDTH = 4;
    public static final int ADMIN_SEQUENCE = 1234;
    public static final String ADMIN_EMPLOYEE_ID = PREFIX + "1234";
    public static final String DEFAULT_PASSWORD = "1234";
    public static final String INVALID_FORMAT_MESSAGE = "아이디는 asm-0001 형식으로 입력해 주세요.";
    public static final String LOGIN_FAILED_MESSAGE = "아이디 또는 비밀번호를 확인해 주세요.";

    private static final Pattern EMPLOYEE_ID_PATTERN = Pattern.compile("^asm-\\d{4}$");

    private EmployeeIdPolicy() {
    }

    public static boolean isValid(String employeeId) {
        return employeeId != null && EMPLOYEE_ID_PATTERN.matcher(employeeId).matches();
    }

    public static boolean isAdmin(String employeeId) {
        return ADMIN_EMPLOYEE_ID.equals(employeeId);
    }

    public static String formatSequence(int sequence) {
        return PREFIX + String.format("%0" + ID_WIDTH + "d", sequence);
    }

    public static int extractSequence(String employeeId) {
        if (!isValid(employeeId)) {
            throw new IllegalArgumentException(INVALID_FORMAT_MESSAGE);
        }
        return Integer.parseInt(employeeId.substring(PREFIX.length()));
    }
}
