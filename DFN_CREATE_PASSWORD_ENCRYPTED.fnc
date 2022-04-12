

CREATE OR REPLACE FUNCTION dfn_create_password_encrypted (
   USERCODE   IN   VARCHAR2,
   USERPAWD   IN   VARCHAR2
)
   RETURN VARCHAR2
IS
BEGIN
   RETURN custom_hash (USERCODE, USERPAWD); --(dpk_stelar_security.dfn_create_password_encrypted (userid, passwd)  );
          dbms_output.put_line(USERCODE);
END;