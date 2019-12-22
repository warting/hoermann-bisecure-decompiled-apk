package com.adobe.air.utils;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.CodingErrorAction;

public class CharsetUtils {
    public static final byte[] EMPTY_BARRAY = new byte[0];
    public static final char[] EMPTY_CARRAY = new char[0];
    public static final String LOG_TAG = CharsetUtils.class.toString();

    public static byte[] utf16ToUtf8(char[] utf16Buf) {
        try {
            byte[] utf8Buf = Charset.forName("UTF-8").newEncoder().encode(CharBuffer.wrap(utf16Buf)).array();
            if (utf8Buf == null) {
                return EMPTY_BARRAY;
            }
            return utf8Buf;
        } catch (Exception e) {
            return EMPTY_BARRAY;
        }
    }

    public static char[] mbcsToUtf16(byte[] mbcsBuf) {
        try {
            char[] utf16Buf = Charset.forName("ISO-8859-1").newDecoder().decode(ByteBuffer.wrap(mbcsBuf)).array();
            if (utf16Buf == null) {
                return EMPTY_CARRAY;
            }
            return utf16Buf;
        } catch (Exception e) {
            return EMPTY_CARRAY;
        }
    }

    public static byte[] mbcsToUtf8(byte[] mbcsBuf) {
        return utf16ToUtf8(mbcsToUtf16(mbcsBuf));
    }

    public static CharBuffer DecodeBuffer(byte[] buf, String charsetName) throws CharacterCodingException {
        CharsetDecoder decoder = Charset.forName(charsetName).newDecoder();
        decoder.onUnmappableCharacter(CodingErrorAction.REPLACE);
        return decoder.decode(ByteBuffer.wrap(buf));
    }

    public static byte[] ConvertMBCStoUTF16(byte[] mbcs, String charsetName) {
        try {
            return Charset.forName("UTF-16LE").encode(DecodeBuffer(mbcs, charsetName)).array();
        } catch (Exception e) {
            return EMPTY_BARRAY;
        }
    }

    public static byte[] ConvertUTF16toMBCS(byte[] utf16, String charsetName) {
        try {
            CharBuffer cbuf = DecodeBuffer(utf16, "UTF-16LE");
            CharsetEncoder encoder = Charset.forName(charsetName).newEncoder();
            encoder.onUnmappableCharacter(CodingErrorAction.REPLACE);
            return encoder.encode(cbuf).array();
        } catch (Exception e) {
            return EMPTY_BARRAY;
        }
    }

    public static byte[] ConvertUTF8toMBCS(byte[] utf8, String charsetName) {
        try {
            CharBuffer cbuf = DecodeBuffer(utf8, "UTF-8");
            CharsetEncoder encoder = Charset.forName(charsetName).newEncoder();
            encoder.onUnmappableCharacter(CodingErrorAction.REPLACE);
            return encoder.encode(cbuf).array();
        } catch (Exception e) {
            return EMPTY_BARRAY;
        }
    }

    public static byte[] ConvertMBCStoUTF8(byte[] mbcs, String charsetName) {
        try {
            return Charset.forName("UTF-8").newEncoder().encode(DecodeBuffer(mbcs, charsetName)).array();
        } catch (Exception e) {
            return EMPTY_BARRAY;
        }
    }

    public static String QueryAvailableCharsets() {
        String allCharsets = "";
        for (String name : Charset.availableCharsets().keySet()) {
            allCharsets = allCharsets + name + " ";
        }
        return allCharsets;
    }
}
