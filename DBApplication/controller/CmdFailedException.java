package DBApplication.controller;

import DBApplication.model.SoundgoodException;

public class CmdFailedException extends Exception {

    public CmdFailedException(String msg, SoundgoodException se) {
        super(msg, se);
    }
}
