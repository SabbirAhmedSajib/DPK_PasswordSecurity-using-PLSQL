
declare
vout_errnum number;
vout_errdes varchar2(1000);
begin
hr.dpk_passwordsecurity.dpr_usrpass_chk (p_USERCODE  => '100140',
                               p_USERPAWD => '123456',
                               out_errnum  =>    vout_errnum,
                               out_errdes  => vout_errdes);
                               
                               dbms_output.put_line(vout_errnum||';'||vout_errdes);
end;




