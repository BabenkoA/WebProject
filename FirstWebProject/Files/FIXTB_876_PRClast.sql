/* Formatted on 15/09/2021 14:06:58 (QP5 v5.115.810.9015) */
--FIXTB_876_TKT
DECLARE

contract_number             VARCHAR2 (100)      := null;
text                        VARCHAR2 (32000)    := null;
TEXT_ACT                    VARCHAR2 (32000)    := null;
error_txt                   VARCHAR2 (100)      := null;
mx                          integer             := 0;
temp                        integer             := 0;
TEMP_ACT                    integer             := 0;
TEXT_ACT_ALL                VARCHAR2 (32000)    := null;


BEGIN
    FOR e IN (
                SELECT T.*
                FROM (
                    SELECT 
                        DISTINCT ft.SRQ_DAT_OPEN,CONTRACT_NUMBER, ft.sr_id, o.x_platform as contract_platform,o.x_operator as contract_operator
                    FROM SKYWORK.FIXTB_876_tkt FT,siebel.s_order o
                    where ft.contract_number = o.order_num
                ) T
                WHERE T.contract_number = '53654400'
                order by 1 desc
    )   
    LOOP
            TEXT := '';
            TEMP := 0;
            
            TEMP_ACT := 0;
            TEXT_ACT := '';
            TEXT_ACT_ALL := '';
            
            FOR ACT IN (
                SELECT DISTINCT
                     ft.SRQ_DES_SR_CATEGORY
                    ,ft.SRQ_DES_SR_SUB_CATEGORY
                    ,ft.Activity
                FROM 
                    SKYWORK.FIXTB_876_tkt FT
                   ,SIEBEL.S_ORDER O
                WHERE 
                         ft.contract_number = e.contract_number
                    and ft.sr_id = e.sr_id
                    and ft.contract_number = o.order_num
                    and ft.ACTIVITY_PLAN not like 'SR-%'
                    and ft.activity not in ('Aktivierungen','Briefversand')
            ) LOOP
                
                IF (TEMP_ACT = 0) THEN
                
                    TEXT_ACT := ACT.activity;
                    
                ELSE
                
                    TEXT_ACT := TEXT_ACT ||','||act.activity;
                
                END IF;
                
                TEMP_ACT:= TEMP_ACT+1;
                
            END LOOP;
            
             DBMS_OUTPUT.put_line(TEXT_ACT);
            
            FOR F IN (
            
                SELECT DISTINCT
                     ft.CUSTOMER_NUMBER
                    ,ft.sr_id
                    ,ft.allsr_id
                    ,to_date(ft.SRQ_DAT_OPEN,'DD/MM/YYYY') SRQ_DAT_OPEN
                    ,ft.SRQ_DES_SR_CATEGORY
                    ,ft.SRQ_DES_SR_SUB_CATEGORY
                    ,ft.SRQ_DES_SR_REASON
                    ,ft.SRQ_DES_SR_REASON_DETAIL
                    ,ft.SRQ_DES_SR_RESULT
                    ,REPLACE(REPLACE(REPLACE (ft.SRQ_DES_NOTE , CHR(10), ' '),CHR(13),'.'),';','.') as SRQ_DES_NOTE
                    ,ft.PLATFORM
                    ,o.x_operator PLATFORMCATEGORY
                    --,ft.Activity
                    ,to_date(ft.SRALL_DAT_OPEN,'DD/MM/YYYY') SRALL_DAT_OPEN
                    ,ft.CNC_DES_CONTACT_CHANNEL
                    ,ft.SRALL_DES_SR_CATEGORY
                    ,ft.SRALL_DES_SR_SUB_CATEGORY
                    ,ft.SRALL_DES_SR_REASON
                    ,ft.SRALL_DES_SR_REASON_DETAIL
                    ,ft.SRALL_DES_SR_RESULT
                    ,REPLACE(REPLACE(REPLACE (ft.SRALL_DES_NOTE , CHR(10), ' '),CHR(13),'.'),';','.') as SRALL_DES_NOTE
                    ,ft.PLATFORM_ALL
                    ,ft.ACTIVITY_PLAN
                    --,ft.ActivityAll
                FROM 
                    SKYWORK.FIXTB_876_tkt FT
                   ,SIEBEL.S_ORDER O
                WHERE 
                         ft.contract_number = e.contract_number
                    and ft.sr_id = e.sr_id
                    and ft.contract_number = o.order_num
                    and ft.ACTIVITY_PLAN not like 'SR-%'
                    and ft.activity not in ('Aktivierungen','Briefversand')
                ORDER BY 
                        4 DESC,13  DESC
        ) LOOP
        
                TEMP_ACT := 0;
                TEXT_ACT_ALL := '';
                
                FOR ACT IN (
                     SELECT DISTINCT
                         ft.CUSTOMER_NUMBER
                        ,ft.sr_id 
                        ,ft.allsr_id
                        ,to_date(ft.SRALL_DAT_OPEN,'DD/MM/YYYY') SRALL_DAT_OPEN
                        ,ft.CNC_DES_CONTACT_CHANNEL
                        ,ft.SRALL_DES_SR_CATEGORY
                        ,ft.SRALL_DES_SR_SUB_CATEGORY
                        ,ft.PLATFORM_ALL
                        ,ft.ACTIVITY_PLAN
                        ,ft.ActivityAll
                    FROM 
                        SKYWORK.FIXTB_876_tkt FT
                       ,SIEBEL.S_ORDER O
                    WHERE 
                            ft.contract_number = e.contract_number
                        and ft.allsr_id = f.allsr_id
                        and ft.sr_id = f.sr_id
                        and ft.contract_number = o.order_num
                        and ft.ACTIVITY_PLAN not like 'SR-%'
                        and ft.activity not in ('Aktivierungen','Briefversand')
                ) LOOP
                        
                    IF (TEMP_ACT = 0) THEN
                        
                        TEXT_ACT_ALL := ACT.ActivityAll;
                            
                    ELSE
                        
                        TEXT_ACT_ALL := TEXT_ACT_ALL ||','||act.ActivityAll;
                        
                    END IF;
                        
                    TEMP_ACT:= TEMP_ACT+1;
                        
                END LOOP;
                    
                IF temp = 0 THEN
                        
                   text := e.contract_number||';'||f.CUSTOMER_NUMBER||';'||to_char(f.SRQ_DAT_OPEN,'DD/MM/YYYY')||';'||f.SRQ_DES_SR_CATEGORY||';'||f.SRQ_DES_SR_SUB_CATEGORY||';'||f.SRQ_DES_SR_REASON||';'||f.SRQ_DES_SR_REASON_DETAIL||';'||f.SRQ_DES_SR_RESULT||';'||nvl(f.SRQ_DES_NOTE,'-')||';'||f.PLATFORM||';'||f.PLATFORMCATEGORY||';'||TEXT_ACT||';'||to_char(f.SRALL_DAT_OPEN,'DD/MM/YYYY')||';'||f.CNC_DES_CONTACT_CHANNEL||';'|| f.SRALL_DES_SR_CATEGORY||';'||f.SRALL_DES_SR_SUB_CATEGORY||';'||f.SRALL_DES_SR_REASON||';'||f.SRALL_DES_SR_REASON_DETAIL||';'||f.SRALL_DES_SR_RESULT||';'||nvl(f.SRALL_DES_NOTE,'-')||';'||f.PLATFORM_ALL||';'||f.PLATFORMCATEGORY||';'||f.ACTIVITY_PLAN||';'||TEXT_ACT_ALL;
                            
                   INSERT INTO FIXTB_876_TKT_TEXT_OUT  (CONTRACT_NUMBER,TEXT_OUT) VALUES (e.contract_number,text);
                   COMMIT;
                ELSE
                           
                   text := ';'||to_char(f.SRALL_DAT_OPEN,'DD/MM/YYYY')||';'||f.CNC_DES_CONTACT_CHANNEL||';'|| f.SRALL_DES_SR_CATEGORY||';'||f.SRALL_DES_SR_SUB_CATEGORY||';'||f.SRALL_DES_SR_REASON||';'||f.SRALL_DES_SR_REASON_DETAIL||';'||f.SRALL_DES_SR_RESULT||';'||nvl(f.SRALL_DES_NOTE,'-')||';'||f.PLATFORM_ALL||';'||f.PLATFORMCATEGORY||';'||f.ACTIVITY_PLAN||';'||TEXT_ACT_ALL;
                           
                   UPDATE FIXTB_876_TKT_TEXT_OUT  SET TEXT_OUT = TEXT_OUT||text WHERE CONTRACT_NUMBER = e.contract_number;
                   COMMIT;
                        
                END IF;
                        
                --DBMS_OUTPUT.put_line('---->'||TEXT_ACT_ALL);

                temp:= temp+1;
                        
                IF temp > mx THEN
                    mx := temp;
                END IF;
            
        END LOOP;
    
    END LOOP;


EXCEPTION
    WHEN OTHERS
    THEN
        error_txt := 'sql error: '|| SQLERRM || ' code: ' || SQLCODE;
        DBMS_OUTPUT.put_line (error_txt);
        --st_temp:= 'Contract_Number;Contract_Platform'||st_temp;
END;