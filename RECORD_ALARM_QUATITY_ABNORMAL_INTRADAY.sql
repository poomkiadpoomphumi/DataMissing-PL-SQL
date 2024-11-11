create or replace PROCEDURE                                                                                                                          RECORD_ALARM_QUANTITY_ABNORMAL_INTRADAY_PROCEDURE (PARAMS_DATE IN DATE) AS
    F_TIME TIMESTAMP;
    L_TIME TIMESTAMP;
    HOUR NUMBER;
    LIMIT_DIFF INT := 10;
    DESCRIPTION VARCHAR(500 BYTE);
    CURSOR DATA_INTRADAY IS 
        SELECT
            METER_ID,
            REALTIME_SCADA_VOLUME_TAG_1,
            TO_TIMESTAMP(TIME, 'DD-MON-YY HH:MI:SS.FF AM') AS TIME,
            TO_TIMESTAMP(PREVIOUS_TIME_1, 'DD-MON-YY HH:MI:SS.FF AM') AS PREVIOUS_TIME_1,
            TO_TIMESTAMP(PREVIOUS_TIME_2, 'DD-MON-YY HH:MI:SS.FF AM') AS PREVIOUS_TIME_2,
            METER_NAME, CUSTOMER_TYPE, ENERGY,
            NVL(PREVIOUS_ENERGY_1, 0) AS PREVIOUS_ENERGY_1,
            NVL(PREVIOUS_ENERGY_2, 0) AS PREVIOUS_ENERGY_2,
            -- Case compare energy current hour, previous hour to column ENERGY_COMPARISON to view
            CASE
                WHEN ENERGY = 0 AND NVL(PREVIOUS_ENERGY_1, 0) = 0 AND NVL(PREVIOUS_ENERGY_2, 0) = 0 THEN NULL -- Gas not used (Normal)
                WHEN ENERGY != 0 AND NVL(PREVIOUS_ENERGY_1, 0) = 0 AND NVL(PREVIOUS_ENERGY_2, 0) = 0 THEN NULL -- Start Gas day 1.00 AM (Normal)
                WHEN ENERGY = NVL(PREVIOUS_ENERGY_1, 0) THEN NULL -- The current hourly gas value is the same as the previous hour. (Normal)
                WHEN  NULLIF(NVL(PREVIOUS_ENERGY_2, 0), 0 - NVL(PREVIOUS_ENERGY_1, 0)) > LIMIT_DIFF --check if d2-d1 > 10 is cal and != exit 
                THEN
                    ABS(
                            (ENERGY - NVL(PREVIOUS_ENERGY_1, 0)) / NULLIF(EXTRACT(HOUR FROM TIME - PREVIOUS_TIME_1), 0) * 
                             -- If time is NULL TRUNC time to 00:00 --
                             NULLIF(EXTRACT(HOUR FROM PREVIOUS_TIME_1 - CASE WHEN PREVIOUS_TIME_2 IS NULL THEN TRUNC(TIME) ELSE PREVIOUS_TIME_2 END ), 0) / 
                             NULLIF(NVL(PREVIOUS_ENERGY_1, 0) - NVL(PREVIOUS_ENERGY_2, 0), 0)
                        )
                ELSE NULL
            END AS ENERGY_COMPARISON,
            CASE 
                WHEN TIME - PREVIOUS_TIME_1 > INTERVAL '1' HOUR THEN TIME - PREVIOUS_TIME_1
                ELSE TIME - PREVIOUS_TIME_1
            END AS DIFF_TIME
            -- End case compare energy current hour, previous hour to column ENERGY_COMPARISON to view
        FROM (
            SELECT
                VW_SUMMARY.METER_ID,
                VW_SUMMARY.REALTIME_SCADA_VOLUME_TAG_1,
                MASTER_METER.VW_OUTPUT_TPA_INTRADAY.TIME,
                VW_SUMMARY.METER_NAME,VW_SUMMARY.CUSTOMER_TYPE,
                MASTER_METER.VW_OUTPUT_TPA_INTRADAY.ENERGY AS ENERGY,
                -- PARTITION BY VW_SUMMARY.REALTIME_SCADA_VOLUME_TAG_1: 
                -- This part of the query is specifying that the window function (LAG in this case) 
                -- should operate independently for each distinct value of VW_SUMMARY.REALTIME_SCADA_VOLUME_TAG_1. 
                -- It means that the rows will be divided into partitions based on the values in the column REALTIME_SCADA_VOLUME_TAG_1. 
                -- Within each partition, the LAG function will restart its calculations
                -- ORDER BY MASTER_METER.VW_OUTPUT_TPA_INTRADAY.TIME: 
                -- This part of the query is specifying the order within each partition. The LAG function will consider the order of rows 
                -- within each partition based on the values in the TIME column
                LAG(MASTER_METER.VW_OUTPUT_TPA_INTRADAY.ENERGY, 1)OVER (PARTITION BY VW_SUMMARY.REALTIME_SCADA_VOLUME_TAG_1 ORDER BY MASTER_METER.VW_OUTPUT_TPA_INTRADAY.TIME) AS PREVIOUS_ENERGY_1,
                LAG(MASTER_METER.VW_OUTPUT_TPA_INTRADAY.ENERGY, 2) OVER (PARTITION BY VW_SUMMARY.REALTIME_SCADA_VOLUME_TAG_1 ORDER BY MASTER_METER.VW_OUTPUT_TPA_INTRADAY.TIME) AS PREVIOUS_ENERGY_2,
                LAG(MASTER_METER.VW_OUTPUT_TPA_INTRADAY.TIME, 1) OVER (PARTITION BY VW_SUMMARY.REALTIME_SCADA_VOLUME_TAG_1 ORDER BY MASTER_METER.VW_OUTPUT_TPA_INTRADAY.TIME) AS PREVIOUS_TIME_1,
                LAG( MASTER_METER.VW_OUTPUT_TPA_INTRADAY.TIME, 2) OVER (PARTITION BY VW_SUMMARY.REALTIME_SCADA_VOLUME_TAG_1 ORDER BY MASTER_METER.VW_OUTPUT_TPA_INTRADAY.TIME) AS PREVIOUS_TIME_2
            FROM
                TABLE(MASTER_METER.SUMMARY_DAILY_MAPPING_ALL_FUNCTION(PARAMS_DATE)) VW_SUMMARY
            LEFT JOIN
                MASTER_METER.VW_OUTPUT_TPA_INTRADAY
            ON
                VW_SUMMARY.METER_NAME = MASTER_METER.VW_OUTPUT_TPA_INTRADAY.METER_NAME
            WHERE
                TRUNC(TIME_STAMP) = TO_DATE(PARAMS_DATE, 'DD-MON-YY')
                AND VW_SUMMARY.REALTIME_SCADA_VOLUME_TAG_1 IN (
                    SELECT MASTER_METER.VW_SUMMARY_DAILY_MAPPING_ALL_D0.REALTIME_SCADA_VOLUME_TAG_1 
                    FROM MASTER_METER.VW_SUMMARY_DAILY_MAPPING_ALL_D0 
                    WHERE REALTIME_SCADA_VOLUME_TAG_1 IS NOT NULL
                )
                -- Midnight is not counted because midnight is yesterday's value.
                AND TO_CHAR(MASTER_METER.VW_OUTPUT_TPA_INTRADAY.TIME, 'HH24:MI:SS') != '00:00:00' 
        ) 
        ORDER BY REALTIME_SCADA_VOLUME_TAG_1, TIME;
    TYPE OBJ_DATA_INTRADAY IS TABLE OF DATA_INTRADAY%ROWTYPE;
    DATA OBJ_DATA_INTRADAY;
    
    
BEGIN
DBMS_OUTPUT.ENABLE(buffer_size => 100000);
    OPEN DATA_INTRADAY;
        FETCH DATA_INTRADAY BULK COLLECT INTO DATA;
    CLOSE DATA_INTRADAY;
        
    FOR I IN 1..DATA.COUNT-1 LOOP
        IF EXTRACT(HOUR FROM DATA(I).DIFF_TIME) = 1 AND DATA(I).DIFF_TIME IS NOT NULL THEN   
            IF DATA(I).ENERGY_COMPARISON < 0.1 AND DATA(I).ENERGY_COMPARISON IS NOT NULL THEN
                DESCRIPTION := 'อัตราการเพิ่ม Energy ช่วง ' || 
                    TO_CHAR(DATA(I).PREVIOUS_TIME_1, 'HH24:MI') || ' ถึง ' || 
                    TO_CHAR(DATA(I).TIME, 'HH24:MI') || ' เทียบกับ ' || 
                    CASE 
                        WHEN DATA(I).PREVIOUS_TIME_2 IS NULL THEN '00:00' 
                        WHEN DATA(I).PREVIOUS_TIME_1 - DATA(I).PREVIOUS_TIME_2 > INTERVAL '1' HOUR THEN 
                             TO_CHAR(DATA(I).PREVIOUS_TIME_1 - INTERVAL '1' HOUR, 'HH24:MI')
                        ELSE TO_CHAR(DATA(I).PREVIOUS_TIME_2, 'HH24:MI') 
                    END || ' ถึง ' || 
                    TO_CHAR(DATA(I).PREVIOUS_TIME_1, 'HH24:MI') || ' < 10%';
                    IF FUNCTION_HANDLE_ALARM_LOG_INTRADAY(DATA(I).TIME, DATA(I).METER_ID, DESCRIPTION, PARAMS_DATE) THEN
                        INSERT INTO MASTER_METER.ALARM_DATA_LOG
                            (GASDAY,METER_ID,SOURCE,ERROR_TYPE,DESCRIPTION,ABNORMAL_CASE) 
                        VALUES
                            (TRUNC(DATA(I).TIME), DATA(I).METER_ID, 6, 2, DESCRIPTION, 13);
                    END IF;
            END IF;
            IF DATA(I).ENERGY_COMPARISON > 1.5 AND DATA(I).ENERGY_COMPARISON IS NOT NULL THEN
                DESCRIPTION := 'อัตราการเพิ่ม Energy ช่วง ' || 
                    TO_CHAR(DATA(I).PREVIOUS_TIME_1, 'HH24:MI') || ' ถึง ' || 
                    TO_CHAR(DATA(I).TIME, 'HH24:MI') || ' เทียบกับ ' || 
                    CASE 
                        WHEN DATA(I).PREVIOUS_TIME_2 IS NULL THEN '00:00' 
                        WHEN DATA(I).PREVIOUS_TIME_1 - DATA(I).PREVIOUS_TIME_2 > INTERVAL '1' HOUR THEN 
                             TO_CHAR(DATA(I).PREVIOUS_TIME_1 - INTERVAL '1' HOUR, 'HH24:MI')
                        ELSE TO_CHAR(DATA(I).PREVIOUS_TIME_2, 'HH24:MI') 
                    END || ' ถึง ' || 
                    TO_CHAR(DATA(I).PREVIOUS_TIME_1, 'HH24:MI') || ' > 150%';
                    IF FUNCTION_HANDLE_ALARM_LOG_INTRADAY(DATA(I).TIME, DATA(I).METER_ID, DESCRIPTION, PARAMS_DATE) THEN
                        INSERT INTO MASTER_METER.ALARM_DATA_LOG
                            (GASDAY,METER_ID,SOURCE,ERROR_TYPE,DESCRIPTION,ABNORMAL_CASE) 
                        VALUES
                            (TRUNC(DATA(I).TIME), DATA(I).METER_ID, 6, 2, DESCRIPTION, 13);
                    END IF;
            END IF;
        END IF;
        -- Calculate the difference between the current time and the next time
        IF DATA(I+1).TIME - DATA(I).TIME = INTERVAL '2' HOUR AND 
           DATA(I+1).TIME - DATA(I).TIME <> INTERVAL '1' HOUR THEN 
            L_TIME := DATA(I).TIME - INTERVAL '1' HOUR;
            DESCRIPTION := 'พบค่าไม่เข้าเวลา '|| TO_CHAR(L_TIME, 'HH24:MI');
            -- Check Function Handle in database return true or false.
            IF FUNCTION_HANDLE_ALARM_LOG_INTRADAY(DATA(I).TIME, DATA(I).METER_ID, DESCRIPTION, PARAMS_DATE) THEN
                INSERT INTO MASTER_METER.ALARM_DATA_LOG
                    (GASDAY,METER_ID,SOURCE,ERROR_TYPE,DESCRIPTION,ABNORMAL_CASE) 
                VALUES
                    (TRUNC(DATA(I).TIME), DATA(I).METER_ID, 6, 1, DESCRIPTION, 5);
            END IF;
        END IF;
        IF DATA(I+1).TIME - DATA(I).TIME > INTERVAL '1' HOUR THEN
            F_TIME := DATA(I+1).TIME - INTERVAL '1' HOUR;
            L_TIME := DATA(I).TIME + INTERVAL '1' HOUR;
            -- Check Function Handle in database return true or false.
            IF FUNCTION_HANDLE_ALARM_LOG_INTRADAY(DATA(I).TIME, DATA(I).METER_ID, DESCRIPTION, PARAMS_DATE) THEN
                FOR HOUR IN TO_NUMBER(SUBSTR(TO_CHAR(L_TIME, 'HH24:MI'), 1, 2)) .. TO_NUMBER(SUBSTR(TO_CHAR(F_TIME, 'HH24:MI'), 1, 2))  LOOP
                    DESCRIPTION := 'พบค่าไม่เข้าช่วงเวลา ' || TO_CHAR(L_TIME, 'HH24:MI') || ' ถึง ' || TO_CHAR(F_TIME, 'HH24:MI') 
                    || ' เวลาที่หาย ' || LPAD(HOUR, 2, '0') || ':00';
                    INSERT INTO MASTER_METER.ALARM_DATA_LOG
                        (GASDAY,METER_ID,SOURCE,ERROR_TYPE,DESCRIPTION,ABNORMAL_CASE) 
                    VALUES
                        (TRUNC(DATA(I).TIME), DATA(I).METER_ID, 6, 1, DESCRIPTION, 5);
                END LOOP;
            END IF;
        END IF;
        
    END LOOP;
END RECORD_ALARM_QUANTITY_ABNORMAL_INTRADAY_PROCEDURE;