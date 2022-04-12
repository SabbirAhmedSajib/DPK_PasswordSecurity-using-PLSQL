create or replace package dpk_passwordsecurity
is
 PROCEDURE dpr_usrpass_chk (p_USERCODE   IN     VARCHAR2,
                               p_USERPAWD  IN     VARCHAR2,
                               out_errnum      OUT NUMBER,
                               out_errdes      OUT CLOB);
                           
FUNCTION dfn_create_password_encrypted (USERCODE   IN VARCHAR2,
                                            USERPAWD   IN VARCHAR2)
                                            RETURN varchar2;
                                           
end dpk_passwordsecurity;