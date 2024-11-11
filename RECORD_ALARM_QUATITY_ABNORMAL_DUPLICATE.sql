create or replace PROCEDURE                                                                                                                                                RECORD_ALARM_QUANTITY_ABNORMAL_DUPLICATE_PROCEDURE 
(
  D IN DATE 
) AS 
    DESCRIPTION                     VARCHAR(500 BYTE);
    YESTERDAY_DIY                   DATE := TO_DATE(TO_TIMESTAMP(D,'DD-MON-YY') - 1 / 24,'DD-MON-YY');
    CURSOR CASE_TODAY IS 
    SELECT 
        RAW_DATA.*,
        GETFUNCTION.METER_NAME
    FROM 
        TABLE(MASTER_METER.SUMMARY_DAILY_MAPPING_ALL_FUNCTION(D)) GETFUNCTION
    LEFT JOIN MASTER_METER.RECORD_DAILY_GET_QUANTITY_RAW_DATA RAW_DATA
    ON GETFUNCTION.METER_ID = RAW_DATA.METER_ID
    WHERE
        TRUNC(RAW_DATA.GASDAY) = TRUNC(D);
    TYPE QUANTITY_DATA IS TABLE OF CASE_TODAY%ROWTYPE;
    TODAY QUANTITY_DATA;
    CURSOR CASE_YESTERDAY IS 
    SELECT 
        RAW_DATA_Y.*,
        GETFUNCTION_Y.METER_NAME
    FROM 
        TABLE(MASTER_METER.SUMMARY_DAILY_MAPPING_ALL_FUNCTION(YESTERDAY_DIY)) GETFUNCTION_Y
    LEFT JOIN MASTER_METER.RECORD_DAILY_GET_QUANTITY_RAW_DATA RAW_DATA_Y
    ON GETFUNCTION_Y.METER_ID = RAW_DATA_Y.METER_ID
    WHERE
        TRUNC(RAW_DATA_Y.GASDAY) = TRUNC(YESTERDAY_DIY);
    TYPE TY_DATA IS TABLE OF CASE_YESTERDAY%ROWTYPE;
    YESTERDAY TY_DATA;
BEGIN
      OPEN CASE_TODAY;
        LOOP
            FETCH CASE_TODAY BULK COLLECT INTO TODAY LIMIT 5000;
            EXIT WHEN TODAY.COUNT = 0;
                OPEN CASE_YESTERDAY;
                    LOOP
                        FETCH CASE_YESTERDAY BULK COLLECT INTO YESTERDAY LIMIT 5000;
                        EXIT WHEN YESTERDAY.COUNT = 0;
                            FOR X IN 1..TODAY.COUNT LOOP
                                FOR Y IN 1..YESTERDAY.COUNT LOOP
                                    IF(TODAY(x).METER_ID = YESTERDAY(Y).METER_ID)THEN
            ----------------------------------------------------------GMDR_SCADA_MAIN-----------------------------------------------------------------------------------
                                        IF( TODAY(X).GMDR_SCADA_MAIN_1_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_1_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_1_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_1_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_1_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_1_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_1_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_1_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_MAIN_1_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_1_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_MAIN_1_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_1_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_MAIN_1_ENERGY = YESTERDAY(Y).GMDR_SCADA_MAIN_1_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_MAIN_1_STDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_1_STDVOL AND
                                               TODAY(X).GMDR_SCADA_MAIN_1_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_1_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA MAIN 1 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,1,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_SCADA_MAIN_2_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_2_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_2_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_2_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_2_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_2_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_2_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_2_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_MAIN_2_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_2_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_MAIN_2_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_2_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_MAIN_2_ENERGY = YESTERDAY(Y).GMDR_SCADA_MAIN_2_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_MAIN_2_STDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_2_STDVOL AND
                                               TODAY(X).GMDR_SCADA_MAIN_2_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_2_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA MAIN 2 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,2,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_SCADA_MAIN_3_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_3_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_3_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_3_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_3_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_2_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_3_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_3_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_MAIN_3_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_3_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_MAIN_3_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_3_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_MAIN_3_ENERGY = YESTERDAY(Y).GMDR_SCADA_MAIN_3_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_MAIN_3_STDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_3_STDVOL AND
                                               TODAY(X).GMDR_SCADA_MAIN_3_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_3_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA MAIN 3 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,3,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_SCADA_MAIN_4_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_4_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_4_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_4_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_4_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_4_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_4_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_4_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_MAIN_4_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_4_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_MAIN_4_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_4_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_MAIN_4_ENERGY = YESTERDAY(Y).GMDR_SCADA_MAIN_4_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_MAIN_4_STDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_4_STDVOL AND
                                               TODAY(X).GMDR_SCADA_MAIN_4_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_4_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA MAIN 4 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,4,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_SCADA_MAIN_5_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_5_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_5_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_5_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_5_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_5_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_5_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_5_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_MAIN_5_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_5_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_MAIN_5_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_5_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_MAIN_5_ENERGY = YESTERDAY(Y).GMDR_SCADA_MAIN_5_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_MAIN_5_STDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_5_STDVOL AND
                                               TODAY(X).GMDR_SCADA_MAIN_5_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_5_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA MAIN 5 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,5,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_SCADA_MAIN_6_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_6_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_6_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_6_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_6_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_MAIN_6_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_MAIN_6_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_6_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_MAIN_6_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_6_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_MAIN_6_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_6_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_MAIN_6_ENERGY = YESTERDAY(Y).GMDR_SCADA_MAIN_6_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_MAIN_6_STDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_6_STDVOL AND
                                               TODAY(X).GMDR_SCADA_MAIN_6_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_MAIN_6_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA MAIN 6 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,6,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
            ----------------------------------------------------------GMDR_SCADA_BACK-----------------------------------------------------------------------------------
                                        IF( TODAY(X).GMDR_SCADA_BACK_1_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_1_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_1_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_1_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_1_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_1_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_1_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_1_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_BACK_1_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_1_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_BACK_1_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_1_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_BACK_1_ENERGY = YESTERDAY(Y).GMDR_SCADA_BACK_1_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_BACK_1_STDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_1_STDVOL AND
                                               TODAY(X).GMDR_SCADA_BACK_1_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_1_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA BACK 1 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,7,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_SCADA_BACK_2_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_2_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_2_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_2_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_2_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_2_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_2_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_2_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_BACK_2_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_2_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_BACK_2_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_2_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_BACK_2_ENERGY = YESTERDAY(Y).GMDR_SCADA_BACK_2_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_BACK_2_STDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_2_STDVOL AND
                                               TODAY(X).GMDR_SCADA_BACK_2_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_2_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA BACK 2 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,8,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_SCADA_BACK_3_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_3_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_3_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_3_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_3_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_2_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_3_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_3_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_BACK_3_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_3_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_BACK_3_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_3_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_BACK_3_ENERGY = YESTERDAY(Y).GMDR_SCADA_BACK_3_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_BACK_3_STDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_3_STDVOL AND
                                               TODAY(X).GMDR_SCADA_BACK_3_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_3_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA BACK 3 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,9,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_SCADA_BACK_4_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_4_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_4_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_4_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_4_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_4_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_4_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_4_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_BACK_4_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_4_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_BACK_4_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_4_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_BACK_4_ENERGY = YESTERDAY(Y).GMDR_SCADA_BACK_4_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_BACK_4_STDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_4_STDVOL AND
                                               TODAY(X).GMDR_SCADA_BACK_4_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_4_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA BACK 4 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,10,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_SCADA_BACK_5_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_5_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_5_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_5_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_5_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_5_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_5_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_5_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_BACK_5_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_5_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_BACK_5_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_5_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_BACK_5_ENERGY = YESTERDAY(Y).GMDR_SCADA_BACK_5_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_BACK_5_STDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_5_STDVOL AND
                                               TODAY(X).GMDR_SCADA_BACK_5_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_5_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA BACK 5 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,11,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_SCADA_BACK_6_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_6_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_6_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_6_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_6_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_SCADA_BACK_6_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_SCADA_BACK_6_ENERGY != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_6_ENERGY != -2 AND 
                                            TODAY(X).GMDR_SCADA_BACK_6_STDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_6_STDVOL != -2 AND
                                            TODAY(X).GMDR_SCADA_BACK_6_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_BACK_6_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_SCADA_BACK_6_ENERGY = YESTERDAY(Y).GMDR_SCADA_BACK_6_ENERGY AND 
                                               TODAY(X).GMDR_SCADA_BACK_6_STDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_6_STDVOL AND
                                               TODAY(X).GMDR_SCADA_BACK_6_SATSTDVOL = YESTERDAY(Y).GMDR_SCADA_BACK_6_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR SCADA BACK 6 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,3,12,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                    ----------------------------------------------------------GMDR_CLIENT_MAIN-----------------------------------------------------------------------------------
                                        IF( TODAY(X).GMDR_CLIENT_MAIN_1_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_1_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_1_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_1_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_1_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_1_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_1_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_1_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_MAIN_1_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_1_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_MAIN_1_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_1_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_MAIN_1_ENERGY = YESTERDAY(Y).GMDR_CLIENT_MAIN_1_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_MAIN_1_STDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_1_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_MAIN_1_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_1_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT MAIN 1 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,1,2,11,DESCRIPTION);
                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_CLIENT_MAIN_2_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_2_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_2_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_2_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_2_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_2_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_2_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_2_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_MAIN_2_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_2_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_MAIN_2_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_2_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_MAIN_2_ENERGY = YESTERDAY(Y).GMDR_CLIENT_MAIN_2_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_MAIN_2_STDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_2_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_MAIN_2_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_2_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT MAIN 2 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,2,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_CLIENT_MAIN_3_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_3_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_3_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_3_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_3_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_2_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_3_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_3_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_MAIN_3_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_3_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_MAIN_3_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_3_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_MAIN_3_ENERGY = YESTERDAY(Y).GMDR_CLIENT_MAIN_3_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_MAIN_3_STDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_3_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_MAIN_3_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_3_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT MAIN 3 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,3,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_CLIENT_MAIN_4_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_4_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_4_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_4_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_4_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_4_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_4_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_4_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_MAIN_4_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_4_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_MAIN_4_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_SCADA_MAIN_4_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_MAIN_4_ENERGY = YESTERDAY(Y).GMDR_CLIENT_MAIN_4_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_MAIN_4_STDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_4_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_MAIN_4_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_4_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT MAIN 4 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,4,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_CLIENT_MAIN_5_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_5_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_5_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_5_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_5_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_5_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_5_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_5_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_MAIN_5_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_5_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_MAIN_5_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_5_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_MAIN_5_ENERGY = YESTERDAY(Y).GMDR_CLIENT_MAIN_5_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_MAIN_5_STDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_5_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_MAIN_5_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_5_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT MAIN 5 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,5,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_CLIENT_MAIN_6_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_6_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_6_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_6_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_6_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_MAIN_6_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_MAIN_6_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_6_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_MAIN_6_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_6_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_MAIN_6_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_MAIN_6_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_MAIN_6_ENERGY = YESTERDAY(Y).GMDR_CLIENT_MAIN_6_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_MAIN_6_STDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_6_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_MAIN_6_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_MAIN_6_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT MAIN 6 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,6,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
            ----------------------------------------------------------GMDR_CLIENT_BACK-----------------------------------------------------------------------------------
                                        IF( TODAY(X).GMDR_CLIENT_BACK_1_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_1_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_1_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_1_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_1_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_1_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_1_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_1_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_BACK_1_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_1_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_BACK_1_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_1_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_BACK_1_ENERGY = YESTERDAY(Y).GMDR_CLIENT_BACK_1_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_BACK_1_STDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_1_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_BACK_1_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_1_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT BACK 1 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,7,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_CLIENT_BACK_2_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_2_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_2_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_2_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_2_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_2_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_2_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_2_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_BACK_2_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_2_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_BACK_2_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_2_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_BACK_2_ENERGY = YESTERDAY(Y).GMDR_CLIENT_BACK_2_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_BACK_2_STDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_2_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_BACK_2_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_2_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT BACK 2 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,8,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_CLIENT_BACK_3_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_3_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_3_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_3_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_3_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_2_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_3_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_3_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_BACK_3_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_3_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_BACK_3_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_3_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_BACK_3_ENERGY = YESTERDAY(Y).GMDR_CLIENT_BACK_3_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_BACK_3_STDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_3_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_BACK_3_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_3_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT BACK 3 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,9,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_CLIENT_BACK_4_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_4_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_4_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_4_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_4_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_4_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_4_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_4_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_BACK_4_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_4_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_BACK_4_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_4_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_BACK_4_ENERGY = YESTERDAY(Y).GMDR_CLIENT_BACK_4_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_BACK_4_STDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_4_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_BACK_4_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_4_SATSTDVOL
                                            )THEN
                                                  DESCRIPTION := 'GMDR CLIENT BACK 4 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,10,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_CLIENT_BACK_5_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_5_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_5_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_5_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_5_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_5_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_5_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_5_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_BACK_5_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_5_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_BACK_5_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_5_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_BACK_5_ENERGY = YESTERDAY(Y).GMDR_CLIENT_BACK_5_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_BACK_5_STDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_5_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_BACK_5_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_5_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT BACK 5 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,11,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
                                        IF( TODAY(X).GMDR_CLIENT_BACK_6_ENERGY IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_6_ENERGY IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_6_STDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_6_STDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_6_SATSTDVOL IS NOT NULL AND YESTERDAY(Y).GMDR_CLIENT_BACK_6_SATSTDVOL IS NOT NULL AND
                                            TODAY(X).GMDR_CLIENT_BACK_6_ENERGY != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_6_ENERGY != -2 AND 
                                            TODAY(X).GMDR_CLIENT_BACK_6_STDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_6_STDVOL != -2 AND
                                            TODAY(X).GMDR_CLIENT_BACK_6_SATSTDVOL != -2 AND YESTERDAY(Y).GMDR_CLIENT_BACK_6_SATSTDVOL != -2
                                        )THEN
                                            IF(TODAY(X).GMDR_CLIENT_BACK_6_ENERGY = YESTERDAY(Y).GMDR_CLIENT_BACK_6_ENERGY AND 
                                               TODAY(X).GMDR_CLIENT_BACK_6_STDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_6_STDVOL AND
                                               TODAY(X).GMDR_CLIENT_BACK_6_SATSTDVOL = YESTERDAY(Y).GMDR_CLIENT_BACK_6_SATSTDVOL
                                            )THEN
                                                 DESCRIPTION := 'GMDR CLIENT BACK 6 ค่าซ้ำกับเมื่อวาน ';
												INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(TODAY(X).GASDAY,TODAY(X).METER_ID,4,12,2,11,DESCRIPTION);

                                            END IF;
                                        END IF;
                                    END IF;
                                END LOOP;
                            END LOOP;
                    END LOOP;
                CLOSE CASE_YESTERDAY;
        END LOOP;
    CLOSE CASE_TODAY;
END RECORD_ALARM_QUANTITY_ABNORMAL_DUPLICATE_PROCEDURE;