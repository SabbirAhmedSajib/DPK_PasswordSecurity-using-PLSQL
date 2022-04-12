CREATE OR REPLACE PACKAGE BODY dpk_passwordsecurity
IS
    PROCEDURE dpr_usrpass_chk (p_USERCODE  IN     VARCHAR2,
                               p_USERPAWD   IN     VARCHAR2,
                               out_errnum      OUT NUMBER,
                               out_errdes      OUT CLOB)
    IS
        outpass      VARCHAR2 (20);
        sydate       DATE := TO_DATE (SYSDATE, 'DD/MM/RRRR');
        tdays        NUMBER (3);
        out_migflg   VARCHAR2 (1);

        out_appflg   syusrmas.appflg%TYPE;

        v_valdflag   syusrmas.valdflag%TYPE;
        v_usertype   syusrmas.usertype%TYPE;
        v_lastlogn   syusrmas.lastlogn%TYPE;
        v_paswdate   syusrmas.paswdate%TYPE;
        v_password   syusrmas.userpawd%TYPE;
        v_emplcode   syusrmas.emplcode%TYPE;
        v_invldcnt   syusrmas.invldcnt%TYPE;
        v_grupcode   syusrmas.grupcode%TYPE;
        v_startime   syusrmas.startime%TYPE;
        v_stoptime   syusrmas.stoptime%TYPE;
        v_strtsusp   syusrmas.strtsusp%TYPE;
        v_stopsusp   syusrmas.stopsusp%TYPE;
        v_chgflg     syusrmas.chgflg%TYPE;
        v_t1         VARCHAR2 (10) := '1234567';
        v_return     NUMBER;
        g_errnum          NUMBER;
        g_errmsg    varchar2(1000);
        g_exception  exception;
    BEGIN
        /* User exist or not checking */
        SELECT COUNT (1)
          INTO g_errnum
          FROM syusrmas
         WHERE USERCODE = p_USERCODE;

        IF g_errnum = 0
        THEN
            out_errnum := 1;
            g_errmsg := 'Username doesn''t exist...';
            RAISE g_exception;
        END IF;
/*
        SELECT COUNT (*)
          INTO g_errnum
          FROM syrights
         WHERE usercode = p_USERCODE;
*/
        --- User Check -------------------
        BEGIN
            IF g_errnum = 0
            THEN
                g_errmsg := 'This User has not been assigned any Rights,
Cannot Login to any Company...,
Contact the System Administrator to get the Rights';
                RAISE g_exception;
            END IF;

            IF p_USERCODE IS NULL
            THEN
                out_errnum := 1;
                g_errmsg :=
                    'User Code Cannot be Null...,Enter a Valid User Code and then Proceed';
                RAISE g_exception;
            END IF;

            IF LENGTH (RTRIM (p_USERCODE)) != 6
            THEN
                out_errnum := 1;
                g_errmsg :=
                    'User Code should be six characters of length...,Enter a Valid User Code of 6 characters and then Proceed';
                RAISE g_exception;
            END IF;

            BEGIN
                SELECT appflg,
                       valdflag,
                       usertype,
                       lastlogn,
                       paswdate,
                       userpawd,
                       emplcode,
                       invldcnt,
                       grupcode,
                       startime,
                       stoptime,
                       NVL (strtsusp, TO_DATE ('15-AUG-1947', 'DD-MON-YYYY')),
                       NVL (stopsusp, TO_DATE ('15-AUG-1947', 'DD-MON-YYYY')),
                       migflg,
                       CHGFLG
                  INTO out_appflg,
                       v_valdflag,
                       v_usertype,
                       v_lastlogn,
                       v_paswdate,
                       v_password,
                       v_emplcode,
                       v_invldcnt,
                       v_grupcode,
                       v_startime,
                       v_stoptime,
                       v_strtsusp,
                       v_stopsusp,
                       out_migflg,
                       v_chgflg
                  FROM syusrmas
                 WHERE usercode = p_USERCODE;

                IF out_appflg = 'N'
                THEN
                    out_errnum := 1;
                    g_errmsg :=
                        'Waiting for Approval. Conatct SYSTEM Adminstrator.';
                    RAISE g_exception;
                END IF;

                IF NVL (v_usertype, 'X') != 'L'
                THEN
                    out_errnum := 1;
                    g_errmsg :=
                        'You are not a Login User...,Inform the System Administrator to check the User Type for your User Code';
                    RAISE g_exception;
                END IF;

                IF     NVL (v_invldcnt, 0) >= 5
                   AND p_USERCODE NOT IN ('SYSTEM', 'SUSER')
                THEN
                    out_errnum := 1;
                    g_errmsg :=
                        'Login Denied...,Exceeded the Max. No. of Invalid Attempts';
                    RAISE g_exception;
                END IF;

                IF out_migflg IN ('N', 'Y')
                THEN
                    outpass :=
                        hr.dfn_create_password_encrypted (p_USERCODE,
                                                       p_USERPAWD);
                END IF;

                IF     ADD_MONTHS (v_paswdate, 3) <= sydate
                   AND p_USERCODE NOT IN ('SYSTEM', 'SUSER')
                THEN
                    UPDATE syusrmas
                       SET valdflag = 'E', chgflg = 'N', statdate = SYSDATE
                     WHERE usercode = p_USERCODE;

                    IF SQL%NOTFOUND
                    THEN
                        out_errnum := 1;
                        g_errmsg :=
                               'Password information is not updated in usrmas against '
                            || p_USERCODE
                            || ' '
                            || SQLERRM;
                        RAISE g_exception;
                    ELSE
                        COMMIT;
                        g_errmsg :=
                            'Your password has expired and your User Account is Deactivated...,Contact the System Administrator and Reactive your User Code';
                        RAISE g_exception;
                    END IF;
                ELSIF     ADD_MONTHS (v_paswdate, 3) - sydate <= 10
                      AND p_USERCODE NOT IN ('SYSTEM', 'SUSER', 'SADMIN')
                THEN
                    tdays := ADD_MONTHS (v_paswdate, 3) - sydate;
                    out_errnum := 1;
                    g_errmsg :=
                           'Your password is going to expire in '
                        || TO_CHAR (tdays)
                        || ' days ...,Please change the Password';
                    RAISE g_exception;
                END IF;

                IF NVL (outpass, 'x') <> NVL (v_password, 'y')
                THEN
                    out_errnum := 1;
                    g_errmsg :=
                        ' Incorrect Password...,Type the Correct Password and Try again(Password is Case Sensitive)';
                    RAISE g_exception;
                ELSE
                    IF v_chgflg = 'N'
                    THEN
                        out_errnum := 2;
                        RAISE g_exception;
                    END IF;

                    v_return := 0;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    out_errnum := 1;
                    g_errmsg :=
                        'Invalid User Code, Type a valid User Code and then Proceed...';
                    RAISE g_exception;
                WHEN TOO_MANY_ROWS
                THEN
                    out_errnum := 1;
                    g_errmsg :=
                        'Too Many rows in SYUSRMAS table...Inform the System Administrator';
                    RAISE g_exception;
            END;
        END;

        out_errnum := v_return;
        out_errdes  := 'Successfully Login';
    EXCEPTION
        WHEN g_exception
        THEN
            out_errdes := g_errmsg;
            out_errnum := out_errnum;
    END dpr_usrpass_chk;

    FUNCTION dfn_create_password_encrypted (USERCODE   IN VARCHAR2,
                                            USERPAWD   IN VARCHAR2)
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN custom_hash (USERCODE, USERPAWD); --(dpk_stelar_security.dfn_create_password_encrypted (userid, passwd)  );
    END dfn_create_password_encrypted;
    
    END ;
