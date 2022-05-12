DECLARE
   P_USERCODE   VARCHAR2 (6);
   P_USERNAME   VARCHAR2 (40);
   P_USERPAWD   VARCHAR2 (1024);
   P_PASWDATE   VARCHAR2 (32767);
   P_VALDFLAG   VARCHAR2 (1);
   P_STATDATE   DATE;
   P_DIVNCODE   VARCHAR2 (3);
   P_USERTYPE   VARCHAR2 (1);
   P_STARTIME   VARCHAR2 (4);
   P_STOPTIME   VARCHAR2 (4);
   P_OPRSTAMP   VARCHAR2 (6);
   P_TIMSTAMP   DATE;
   P_EXPRDTE    NUMBER;
   P_EMPLCODE   VARCHAR2 (10);
   P_EMPLYDOB   DATE;
   P_GRUPCODE   VARCHAR2 (6);
   P_ADDRESS    VARCHAR2 (30);
   P_EMAILID    VARCHAR2 (30);
   P_MOBILENO   VARCHAR2 (20);
   P_ERRNUM     NUMBER;
   P_ERRMSG     CLOB;
BEGIN
   P_USERCODE := '100151';
   P_USERNAME := 'Sajib';
   P_USERPAWD := '123456';
   P_PASWDATE := '04-apr-2022';
   P_VALDFLAG := 'A';
   P_STATDATE := null;
   P_DIVNCODE := '001';
   P_USERTYPE := 'L';
   P_STARTIME := '0000';
   P_STOPTIME := '2359';
   P_OPRSTAMP := 'L';
   P_TIMSTAMP := null;
   P_EXPRDTE := NULL;
   P_EMPLCODE := '00215';
   P_EMPLYDOB := NULL;
   P_GRUPCODE := NULL;
   P_ADDRESS := 'Dhaka';
   P_EMAILID := 'a@gmail.com';
   P_MOBILENO := '2554554';
   P_ERRNUM := NULL;
   P_ERRMSG := NULL;

   LOCKER.DPK_USERMGT_INSUPD.DPR_INSERT_SYUSRMAS (P_USERCODE,
                                                  P_USERNAME,
                                                  P_USERPAWD,
                                                  P_PASWDATE,
                                                  P_VALDFLAG,
                                                  P_STATDATE,
                                                  P_DIVNCODE,
                                                  P_USERTYPE,
                                                  P_STARTIME,
                                                  P_STOPTIME,
                                                  P_OPRSTAMP,
                                                  P_TIMSTAMP,
                                                  P_EXPRDTE,
                                                  P_EMPLCODE,
                                                  P_EMPLYDOB,
                                                  P_GRUPCODE,
                                                  P_ADDRESS,
                                                  P_EMAILID,
                                                  P_MOBILENO,
                                                  P_ERRNUM,
                                                  P_ERRMSG);

   dbms_output.put_line(P_ERRNUM||P_ERRMSG);
END;