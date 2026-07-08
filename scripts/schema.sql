-- KaziMatch Schema for MariaDB 10.6
-- Paste into phpMyAdmin → SQL tab → Go

CREATE TABLE IF NOT EXISTS `Candidate` (
  `id` VARCHAR(191) NOT NULL PRIMARY KEY,
  `phone` VARCHAR(191) NOT NULL,
  `email` VARCHAR(191) DEFAULT NULL,
  `name` VARCHAR(191) NOT NULL,
  `location` VARCHAR(191) DEFAULT NULL,
  `status` VARCHAR(191) NOT NULL DEFAULT 'onboarding',
  `rawCvText` LONGTEXT DEFAULT NULL,
  `cvFileName` VARCHAR(191) DEFAULT NULL,
  `cvInputMethod` VARCHAR(191) DEFAULT NULL,
  `parsedProfile` JSON DEFAULT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  UNIQUE INDEX `Candidate_phone_key` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `CandidateQualification` (
  `id` VARCHAR(191) NOT NULL PRIMARY KEY,
  `candidateId` VARCHAR(191) NOT NULL,
  `type` VARCHAR(191) NOT NULL,
  `field` VARCHAR(191) NOT NULL,
  `fieldTag` VARCHAR(191) DEFAULT NULL,
  `parentField` VARCHAR(191) DEFAULT NULL,
  `institution` VARCHAR(191) DEFAULT NULL,
  `year` VARCHAR(191) DEFAULT NULL,
  `confidence` DOUBLE DEFAULT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  INDEX `CandidateQualification_candidateId_idx` (`candidateId`),
  CONSTRAINT `CandidateQualification_candidateId_fkey` FOREIGN KEY (`candidateId`) REFERENCES `Candidate`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `CandidateSkill` (
  `id` VARCHAR(191) NOT NULL PRIMARY KEY,
  `candidateId` VARCHAR(191) NOT NULL,
  `skill` VARCHAR(191) NOT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  UNIQUE INDEX `CandidateSkill_candidateId_skill_key` (`candidateId`, `skill`),
  INDEX `CandidateSkill_candidateId_idx` (`candidateId`),
  CONSTRAINT `CandidateSkill_candidateId_fkey` FOREIGN KEY (`candidateId`) REFERENCES `Candidate`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `CandidateExperience` (
  `id` VARCHAR(191) NOT NULL PRIMARY KEY,
  `candidateId` VARCHAR(191) NOT NULL,
  `title` VARCHAR(191) NOT NULL,
  `company` VARCHAR(191) NOT NULL,
  `period` VARCHAR(191) DEFAULT NULL,
  `durationYears` DOUBLE DEFAULT NULL,
  `industry` VARCHAR(191) DEFAULT NULL,
  `seniority` VARCHAR(191) DEFAULT NULL,
  `isCurrent` BOOLEAN NOT NULL DEFAULT FALSE,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  INDEX `CandidateExperience_candidateId_idx` (`candidateId`),
  CONSTRAINT `CandidateExperience_candidateId_fkey` FOREIGN KEY (`candidateId`) REFERENCES `Candidate`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `CandidateTrajectory` (
  `id` VARCHAR(191) NOT NULL PRIMARY KEY,
  `candidateId` VARCHAR(191) NOT NULL,
  `trajectory` VARCHAR(191) NOT NULL,
  `parentField` VARCHAR(191) NOT NULL,
  `role` VARCHAR(191) NOT NULL,
  `yearsInField` DOUBLE DEFAULT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  UNIQUE INDEX `CandidateTrajectory_candidateId_role_key` (`candidateId`, `role`),
  INDEX `CandidateTrajectory_candidateId_idx` (`candidateId`),
  CONSTRAINT `CandidateTrajectory_candidateId_fkey` FOREIGN KEY (`candidateId`) REFERENCES `Candidate`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `Job` (
  `id` VARCHAR(191) NOT NULL PRIMARY KEY,
  `title` VARCHAR(191) NOT NULL,
  `company` VARCHAR(191) NOT NULL,
  `location` VARCHAR(191) DEFAULT NULL,
  `employmentType` VARCHAR(191) DEFAULT NULL,
  `sourceUrl` VARCHAR(191) DEFAULT NULL,
  `sourceType` VARCHAR(191) DEFAULT NULL,
  `status` VARCHAR(191) NOT NULL DEFAULT 'active',
  `rawDescription` LONGTEXT DEFAULT NULL,
  `parsedJob` JSON DEFAULT NULL,
  `fieldTag` VARCHAR(191) DEFAULT NULL,
  `parentFields` VARCHAR(191) NOT NULL DEFAULT '[]',
  `requiredQualLevel` VARCHAR(191) DEFAULT NULL,
  `requiredSkills` VARCHAR(191) NOT NULL DEFAULT '[]',
  `preferredSkills` VARCHAR(191) NOT NULL DEFAULT '[]',
  `experienceReq` VARCHAR(191) DEFAULT NULL,
  `seniority` VARCHAR(191) DEFAULT NULL,
  `postedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `expiresAt` DATETIME(3) DEFAULT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `JobMatch` (
  `id` VARCHAR(191) NOT NULL PRIMARY KEY,
  `candidateId` VARCHAR(191) NOT NULL,
  `jobId` VARCHAR(191) NOT NULL,
  `matchedVia` VARCHAR(191) NOT NULL,
  `matchParents` VARCHAR(191) NOT NULL,
  `score` DOUBLE NOT NULL,
  `qualFit` DOUBLE NOT NULL,
  `skillFit` DOUBLE NOT NULL,
  `expFit` DOUBLE NOT NULL,
  `status` VARCHAR(191) NOT NULL DEFAULT 'new',
  `dismissedAt` DATETIME(3) DEFAULT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  UNIQUE INDEX `JobMatch_candidateId_jobId_key` (`candidateId`, `jobId`),
  INDEX `JobMatch_candidateId_idx` (`candidateId`),
  INDEX `JobMatch_jobId_idx` (`jobId`),
  CONSTRAINT `JobMatch_candidateId_fkey` FOREIGN KEY (`candidateId`) REFERENCES `Candidate`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `JobMatch_jobId_fkey` FOREIGN KEY (`jobId`) REFERENCES `Job`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `CandidateNotification` (
  `id` VARCHAR(191) NOT NULL PRIMARY KEY,
  `candidateId` VARCHAR(191) NOT NULL,
  `type` VARCHAR(191) NOT NULL,
  `channel` VARCHAR(191) NOT NULL,
  `content` TEXT NOT NULL,
  `status` VARCHAR(191) NOT NULL DEFAULT 'pending',
  `sentAt` DATETIME(3) DEFAULT NULL,
  `error` TEXT DEFAULT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  INDEX `CandidateNotification_candidateId_idx` (`candidateId`),
  CONSTRAINT `CandidateNotification_candidateId_fkey` FOREIGN KEY (`candidateId`) REFERENCES `Candidate`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `FieldTaxonomy` (
  `id` VARCHAR(191) NOT NULL PRIMARY KEY,
  `parent` VARCHAR(191) NOT NULL,
  `leafTag` VARCHAR(191) NOT NULL,
  `label` VARCHAR(191) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `isActive` BOOLEAN NOT NULL DEFAULT TRUE,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  UNIQUE INDEX `FieldTaxonomy_parent_leafTag_key` (`parent`, `leafTag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed 16 parent categories with 48 leaf tags
INSERT IGNORE INTO `FieldTaxonomy` (`id`, `parent`, `leafTag`, `label`, `description`) VALUES
('ft_001', 'sales', 'sales_banking', 'Banking Sales', 'Sales roles in banking institutions'),
('ft_002', 'sales', 'sales_general', 'General Sales', 'General sales roles'),
('ft_003', 'sales', 'business_dev_sales', 'Business Development & Sales', 'Strategic BD with sales'),
('ft_004', 'sales', 'real_estate_sales', 'Real Estate Sales', 'Property sales'),
('ft_005', 'accounting_finance', 'accounting', 'Accounting', 'Financial accounting'),
('ft_006', 'accounting_finance', 'auditing', 'Auditing', 'Internal and external audit'),
('ft_007', 'accounting_finance', 'taxation', 'Taxation', 'Tax advisory and compliance'),
('ft_008', 'accounting_finance', 'financial_analysis', 'Financial Analysis', 'Financial planning and analysis'),
('ft_009', 'teaching_education', 'teaching_secondary', 'Secondary Teaching', 'Secondary school teaching'),
('ft_010', 'teaching_education', 'teaching_primary', 'Primary Teaching', 'Primary school teaching'),
('ft_011', 'teaching_education', 'education_administration', 'Education Administration', 'School management'),
('ft_012', 'early_childhood_education', 'ecd_teacher', 'ECD Teacher', 'Early childhood development'),
('ft_013', 'early_childhood_education', 'preschool_teacher', 'Preschool Teacher', 'Preschool and nursery'),
('ft_014', 'early_childhood_education', 'kindergarten_teacher', 'Kindergarten Teacher', 'Kindergarten teaching'),
('ft_015', 'microfinance_sacco', 'sacco_operations', 'SACCO Operations', 'SACCO operations'),
('ft_016', 'microfinance_sacco', 'microfinance_lending', 'Microfinance Lending', 'Microfinance lending'),
('ft_017', 'lab_sciences', 'lab_technology_medical', 'Medical Lab Technology', 'Medical lab technology'),
('ft_018', 'lab_sciences', 'microbiology_pharma', 'Microbiology & Pharmaceutical', 'Microbiology and pharma'),
('ft_019', 'humanitarian', 'refugee_protection', 'Refugee Protection', 'Refugee protection'),
('ft_020', 'humanitarian', 'ngo_program_management', 'NGO Program Management', 'NGO program management'),
('ft_021', 'data_analytics', 'statistics', 'Statistics', 'Statistical analysis'),
('ft_022', 'data_analytics', 'data_analysis', 'Data Analysis', 'Data analysis and reporting'),
('ft_023', 'data_analytics', 'data_engineering', 'Data Engineering', 'Data engineering'),
('ft_024', 'procurement', 'procurement_supply_chain', 'Procurement & Supply Chain', 'Procurement and supply chain'),
('ft_025', 'procurement', 'logistics', 'Logistics', 'Logistics management'),
('ft_026', 'business_operations', 'business_administration', 'Business Administration', 'Business administration'),
('ft_027', 'business_operations', 'commercial_admin', 'Commercial Administration', 'Commercial operations'),
('ft_028', 'business_operations', 'office_administration', 'Office Administration', 'Office management'),
('ft_029', 'legal', 'litigation', 'Litigation', 'Legal litigation'),
('ft_030', 'legal', 'corporate_law', 'Corporate Law', 'Corporate legal advisory'),
('ft_031', 'legal', 'employment_law', 'Employment Law', 'Employment and labor law'),
('ft_032', 'legal', 'commercial_law', 'Commercial Law', 'Commercial law'),
('ft_033', 'nutrition_dietetics', 'clinical_nutrition', 'Clinical Nutrition', 'Clinical nutrition'),
('ft_034', 'nutrition_dietetics', 'community_nutrition', 'Community Nutrition', 'Community nutrition'),
('ft_035', 'nutrition_dietetics', 'food_service_mgt', 'Food Service Management', 'Food service management'),
('ft_036', 'driving_transport', 'professional_driving', 'Professional Driving', 'Professional driving'),
('ft_037', 'driving_transport', 'fleet_management', 'Fleet Management', 'Fleet management'),
('ft_038', 'agribusiness', 'agribusiness_management', 'Agribusiness Management', 'Agribusiness management'),
('ft_039', 'agribusiness', 'agricultural_economics', 'Agricultural Economics', 'Agricultural economics'),
('ft_040', 'agribusiness', 'agricultural_value_chains', 'Agricultural Value Chains', 'Value chain development'),
('ft_041', 'it_digital', 'information_technology', 'Information Technology', 'IT and systems'),
('ft_042', 'it_digital', 'digital_economy', 'Digital Economy', 'Digital transformation'),
('ft_043', 'it_digital', 'software_engineering', 'Software Engineering', 'Software development'),
('ft_044', 'it_digital', 'data_science', 'Data Science', 'Data science and ML'),
('ft_045', 'it_digital', 'fintech_engineering', 'Fintech Engineering', 'Fintech development'),
('ft_046', 'public_health', 'public_health_policy', 'Public Health Policy', 'Public health policy'),
('ft_047', 'public_health', 'epidemiology', 'Epidemiology', 'Disease surveillance'),
('ft_048', 'public_health', 'health_systems_management', 'Health Systems Management', 'Health systems management');