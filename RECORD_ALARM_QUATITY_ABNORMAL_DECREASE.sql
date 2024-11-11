create or replace PROCEDURE                                                                                                                                                RECORD_ALARM_QUANTITY_ABNORMAL_DECREASE_PROCEDURE 
(
  D IN DATE 
) AS 
    COUNT_VOLUME                    FLOAT := 0;
    DESCRIPTION                     VARCHAR(500 BYTE);
    CURSOR RECORD_DAILY_GET_QUANTITY_RAW_DATA IS 
    SELECT
        RAW_DATA.*, 
        GETFUNCTION.METER_NAME
    FROM
        TABLE(MASTER_METER.SUMMARY_DAILY_MAPPING_ALL_FUNCTION(D)) GETFUNCTION
        LEFT JOIN MASTER_METER.RECORD_DAILY_GET_QUANTITY_RAW_DATA RAW_DATA
        ON GETFUNCTION.METER_ID = RAW_DATA.METER_ID
    WHERE
        TRUNC(RAW_DATA.GASDAY) = TRUNC(D);
    TYPE QUANTITY_DATA IS TABLE OF RECORD_DAILY_GET_QUANTITY_RAW_DATA%ROWTYPE;
    DATA1 QUANTITY_DATA;
    
    CURSOR RECORD_DAILY_GET_QUANTITY_RAW_DATA_LOG IS 
            SELECT 
                METER_ID, SOURCE, GASDAY, MAX(VOLUME) KEEP (DENSE_RANK FIRST ORDER BY UPDATE_TIME DESC) AS VOLUME_AT_TIME 
            FROM 
                MASTER_METER.RECORD_DAILY_GET_QUANTITY_RAW_DATA_LOG 
            WHERE 
                TRUNC(GASDAY) = TRUNC(D) AND VOLUME != -2 AND VOLUME IS NOT NULL
            GROUP BY
                METER_ID,SOURCE,GASDAY;
    TYPE QUANTITY_DATA_LOG IS TABLE OF RECORD_DAILY_GET_QUANTITY_RAW_DATA_LOG%ROWTYPE;
    DATA2 QUANTITY_DATA_LOG;
BEGIN
      OPEN RECORD_DAILY_GET_QUANTITY_RAW_DATA;
        LOOP
            FETCH RECORD_DAILY_GET_QUANTITY_RAW_DATA BULK COLLECT INTO DATA1 LIMIT 5000;
            EXIT WHEN DATA1.COUNT = 0;
                OPEN RECORD_DAILY_GET_QUANTITY_RAW_DATA_LOG;
                    LOOP
                        FETCH RECORD_DAILY_GET_QUANTITY_RAW_DATA_LOG BULK COLLECT INTO DATA2 LIMIT 5000;
                        EXIT WHEN DATA2.COUNT = 0;
                        FOR A IN 1..DATA1.COUNT LOOP
                            FOR B IN 1..DATA2.COUNT LOOP
                                IF(DATA1(A).METER_ID = DATA2(B).METER_ID)THEN
                                        IF(DATA2(B).SOURCE = 'REALTIME SCADA VOLUME TAG 1' AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_1 IS NOT NULL AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_1 != -2)THEN
                                            COUNT_VOLUME := DATA1(A).REALTIME_SCADA_VOLUME_TAG_1;
                                                IF(COUNT_VOLUME < DATA2(B).VOLUME_AT_TIME)THEN
                                                    DESCRIPTION := 'REALTIME SCADA VOLUME TAG 1 ค่า VOLUME ลดลงจากชั่วโมงก่อน';
                                                     INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(DATA2(B).GASDAY,DATA2(B).METER_ID,6,1,2,8,DESCRIPTION);
                                                ELSE
                                                    COUNT_VOLUME := 0;
                                                END IF;
                                        ELSIF(DATA2(B).SOURCE = 'REALTIME SCADA VOLUME TAG 2'  AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_2 IS NOT NULL AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_2 != -2)THEN
                                            COUNT_VOLUME := DATA1(A).REALTIME_SCADA_VOLUME_TAG_2;
                                                IF(COUNT_VOLUME < DATA2(B).VOLUME_AT_TIME)THEN
                                                    DESCRIPTION := ' REALTIME SCADA VOLUME TAG 2 ค่า VOLUME ลดลงจากชั่วโมงก่อน';
                                                    INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(DATA2(B).GASDAY,DATA2(B).METER_ID,6,2,2,8,DESCRIPTION);
                                                ELSE
                                                    COUNT_VOLUME := 0;
                                                END IF;
                                        ELSIF(DATA2(B).SOURCE = 'REALTIME SCADA VOLUME TAG 3'  AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_3 IS NOT NULL AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_3 != -2)THEN
                                            COUNT_VOLUME := DATA1(A).REALTIME_SCADA_VOLUME_TAG_3;
                                                IF(COUNT_VOLUME < DATA2(B).VOLUME_AT_TIME)THEN
                                                    DESCRIPTION := 'REALTIME SCADA VOLUME TAG 3 ค่า VOLUME ลดลงจากชั่วโมงก่อน';
                                                    INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(DATA2(B).GASDAY,DATA2(B).METER_ID,6,3,2,8,DESCRIPTION);
                                                ELSE
                                                    COUNT_VOLUME := 0;
                                                END IF;
                                        ELSIF(DATA2(B).SOURCE = 'REALTIME SCADA VOLUME TAG 4'  AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_4 IS NOT NULL AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_4 != -2)THEN
                                            COUNT_VOLUME := DATA1(A).REALTIME_SCADA_VOLUME_TAG_4;
                                                IF(COUNT_VOLUME < DATA2(B).VOLUME_AT_TIME)THEN
                                                    DESCRIPTION := 'REALTIME SCADA VOLUME TAG 4 ค่า VOLUME ลดลงจากชั่วโมงก่อน';
                                                    INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(DATA2(B).GASDAY,DATA2(B).METER_ID,6,4,2,8,DESCRIPTION);
                                                ELSE
                                                    COUNT_VOLUME := 0;
                                                END IF;
                                        ELSIF(DATA2(B).SOURCE = 'REALTIME SCADA VOLUME TAG 5'  AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_5 IS NOT NULL AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_5 != -2)THEN
                                            COUNT_VOLUME := DATA1(A).REALTIME_SCADA_VOLUME_TAG_5;
                                                IF(COUNT_VOLUME < DATA2(B).VOLUME_AT_TIME)THEN
                                                    DESCRIPTION := 'REALTIME SCADA VOLUME TAG 5 ค่า VOLUME ลดลงจากชั่วโมงก่อน';
                                                    INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(DATA2(B).GASDAY,DATA2(B).METER_ID,6,5,2,8,DESCRIPTION);
                                                ELSE
                                                    COUNT_VOLUME := 0;
                                                END IF;
                                        ELSIF(DATA2(B).SOURCE = 'REALTIME SCADA VOLUME TAG 6'  AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_6 IS NOT NULL AND DATA1(A).REALTIME_SCADA_VOLUME_TAG_6 != -2)THEN
                                            COUNT_VOLUME := DATA1(A).REALTIME_SCADA_VOLUME_TAG_6;
                                                IF(COUNT_VOLUME < DATA2(B).VOLUME_AT_TIME)THEN
                                                    DESCRIPTION := 'REALTIME SCADA VOLUME TAG 6 ค่า VOLUME ลดลงจากชั่วโมงก่อน';
                                                    INSERT INTO MASTER_METER.ALARM_DATA_LOG(GASDAY,METER_ID,SOURCE,RUN,ERROR_TYPE,ABNORMAL_CASE,DESCRIPTION)VALUES(DATA2(B).GASDAY,DATA2(B).METER_ID,6,6,2,8,DESCRIPTION);
                                                ELSE
                                                    COUNT_VOLUME := 0;
                                                END IF;
                                        END IF;
                                END IF;
                            END LOOP;
                        END LOOP;
                    END LOOP;
                CLOSE RECORD_DAILY_GET_QUANTITY_RAW_DATA_LOG;
        END LOOP;
    CLOSE RECORD_DAILY_GET_QUANTITY_RAW_DATA;
END RECORD_ALARM_QUANTITY_ABNORMAL_DECREASE_PROCEDURE;