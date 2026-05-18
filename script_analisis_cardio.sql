/* =============================================================================
PROJETO: Análise de Risco Cardiovascular - La Plata 2025
AUTORA: Isabella Alves Bispo De Carvalho
FERRAMENTAS: MySQL / PopSQL
DESCRIÇÃO: Script de limpeza, normalização e engenharia de dados clínicos
           baseado nos consensos da Sociedad Argentina de Cardiología (SAC).
=============================================================================
*/

-- 1. CONFIGURAÇÃO DO AMBIENTE
CREATE DATABASE IF NOT EXISTS proyecto_cardio;
USE proyecto_cardio;

-- 2. LIMPEZA E NORMALIZAÇÃO DE DADOS (Tratamento de Encoding e Erros de Digitação)
-- Corrigindo caracteres especiais corrompidos na importação
UPDATE Cardiologia_2025 SET Antecedentes_Familiares = 'Si' WHERE Antecedentes_Familiares LIKE 'S%';
UPDATE Cardiologia_2025 SET Fumador = 'Si' WHERE Fumador LIKE 'S%';
UPDATE Cardiologia_2025 SET Uso_Medicacion = 'Si' WHERE Uso_Medicacion LIKE 'S%';
UPDATE Cardiologia_2025 SET Alteracion_ECG = 'Si' WHERE Alteracion_ECG LIKE 'S%' AND Alteracion_ECG NOT LIKE 'Sinusal%';

-- Padronização de nomes de medicamentos
UPDATE Cardiologia_2025 SET Medicacion_Actual = 'Losartán' WHERE Medicacion_Actual LIKE 'Losart%';

-- 3. CLASSIFICAÇÃO DE HIPERTENSÃO (Critérios SAC)
ALTER TABLE Cardiologia_2025 ADD COLUMN Categoria_HTA VARCHAR(50);

UPDATE Cardiologia_2025
SET Categoria_HTA = CASE 
    WHEN (TAS_mmHg >= 130 AND TAS_mmHg < 140) OR (TAD_mmHg >= 85 AND TAD_mmHg < 90) THEN 'Limitrofe'
    WHEN TAS_mmHg >= 140 OR TAD_mmHg >= 90 THEN 'HTA'
    ELSE 'Normotension'
END;

-- 4. CLASSIFICAÇÃO LIPÍDICA (LDL E COLESTEROL)
ALTER TABLE Cardiologia_2025 ADD COLUMN Clase_Colesterol_Total VARCHAR(30), ADD COLUMN Clase_LDL VARCHAR(30);

UPDATE Cardiologia_2025
SET Clase_Colesterol_Total = CASE 
    WHEN Colesterol_Total_mgdl >= 240 THEN 'Alto'
    WHEN Colesterol_Total_mgdl >= 200 THEN 'Limitrofe'
    ELSE 'Normal'
END;

UPDATE Cardiologia_2025
SET Clase_LDL = CASE 
    WHEN LDL_mgdl >= 160 THEN 'Alto'
    WHEN LDL_mgdl >= 130 THEN 'Limitrofe'
    ELSE 'Normal'
END;

-- 5. ESTILO DE VIDA E ATIVIDADE FÍSICA
ALTER TABLE Cardiologia_2025 ADD COLUMN Estado_Fisico VARCHAR(20);

UPDATE Cardiologia_2025
SET Estado_Fisico = CASE 
    WHEN Actividad_Fisica = 'Baja' THEN 'Sedentario'
    WHEN Actividad_Fisica IN ('Media', 'Alta') THEN 'Ativo'
    ELSE 'No especificado'
END;

-- 6. SCORE DE RISCO CARDIOVASCULAR (Algoritmo Multicausal)
ALTER TABLE Cardiologia_2025 ADD COLUMN Riesgo_Cardiovascular VARCHAR(20);

UPDATE Cardiologia_2025
SET Riesgo_Cardiovascular = CASE 
    WHEN (CASE WHEN Categoria_HTA = 'HTA' THEN 1 ELSE 0 END +
          CASE WHEN Clase_LDL = 'Alto' THEN 1 ELSE 0 END +
          CASE WHEN Estado_Fisico = 'Sedentario' THEN 1 ELSE 0 END +
          CASE WHEN Fumador = 'Si' THEN 1 ELSE 0 END +
          CASE WHEN Edad > 65 THEN 1 ELSE 0 END +
          CASE WHEN Antecedentes_Familiares = 'Si' THEN 1 ELSE 0 END) >= 3 THEN 'Alto'
    WHEN (CASE WHEN Categoria_HTA = 'HTA' THEN 1 ELSE 0 END +
          CASE WHEN Clase_LDL = 'Alto' THEN 1 ELSE 0 END +
          CASE WHEN Estado_Fisico = 'Sedentario' THEN 1 ELSE 0 END +
          CASE WHEN Fumador = 'Si' THEN 1 ELSE 0 END +
          CASE WHEN Edad > 65 THEN 1 ELSE 0 END +
          CASE WHEN Antecedentes_Familiares = 'Si' THEN 1 ELSE 0 END) BETWEEN 1 AND 2 THEN 'Medio'
    ELSE 'Bajo'
END;

-- 7. GESTÃO DE METAS TERAPÊUTICAS (Objetivos de LDL por Risco)
ALTER TABLE Cardiologia_2025 ADD COLUMN Objetivo_LDL INT, ADD COLUMN Estado_Meta VARCHAR(20);

UPDATE Cardiologia_2025
SET Objetivo_LDL = CASE 
    WHEN Riesgo_Cardiovascular = 'Alto' THEN 70
    WHEN Riesgo_Cardiovascular = 'Medio' THEN 100
    ELSE 130
END;

UPDATE Cardiologia_2025
SET Estado_Meta = CASE 
    WHEN LDL_mgdl < Objetivo_LDL THEN 'Cumple'
    ELSE 'No Cumple'
END;

-- 8. SAÚDE DA MULHER (Perfil Menopáusico)
ALTER TABLE Cardiologia_2025 ADD COLUMN Perfil_Menopausico VARCHAR(30);

UPDATE Cardiologia_2025
SET Perfil_Menopausico = CASE 
    WHEN Sexo = 'F' AND Edad >= 40 THEN 'Postmenopausia/Transición'
    WHEN Sexo = 'F' AND Edad < 40 THEN 'Premenopausia'
    ELSE 'No aplica'
END;

-- 9. ANÁLISE TEMPORAL (Tratamento de Datas)
ALTER TABLE Cardiologia_2025 ADD COLUMN Mes_Atencion INT, ADD COLUMN Dia_Semana VARCHAR(20), ADD COLUMN Nombre_Mes VARCHAR(20);

UPDATE Cardiologia_2025
SET
    Mes_Atencion = MONTH(STR_TO_DATE(Fecha_Atencion, '%d/%m/%Y')),
    Nombre_Mes = CASE MONTH(STR_TO_DATE(Fecha_Atencion, '%d/%m/%Y'))
        WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre' WHEN 10 THEN 'Octubre' 
        WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
    END,
    Dia_Semana = CASE WEEKDAY(STR_TO_DATE(Fecha_Atencion, '%d/%m/%Y'))
        WHEN 0 THEN 'Lunes' WHEN 1 THEN 'Martes' WHEN 2 THEN 'Miércoles' 
        WHEN 3 THEN 'Jueves' WHEN 4 THEN 'Viernes' WHEN 5 THEN 'Sábado' WHEN 6 THEN 'Domingo'
    END;

-- 10. REFINAMENTO FINAL
ALTER TABLE Cardiologia_2025 RENAME COLUMN IMC_validado TO IMC;

-- CONSULTA FINAL PARA AUDITORIA
SELECT * FROM Cardiologia_2025;