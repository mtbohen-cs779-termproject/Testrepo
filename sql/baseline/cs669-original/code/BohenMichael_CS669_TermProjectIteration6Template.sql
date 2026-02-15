--TABLES

--Drop the previous tables if they exist

DROP TABLE IF EXISTS HostIpAddressHistory;
DROP TABLE IF EXISTS DhcpReservation;
DROP TABLE IF EXISTS Router;
DROP TABLE IF EXISTS Switch;
DROP TABLE IF EXISTS Host;
DROP TABLE IF EXISTS Interface;
DROP TABLE IF EXISTS DhcpScope;
DROP TABLE IF EXISTS LanSubnet;
DROP TABLE IF EXISTS LanSupernet;
DROP TABLE IF EXISTS Device;
DROP TABLE IF EXISTS InternetConnection;
DROP TABLE IF EXISTS Template;
DROP TABLE IF EXISTS Site;
DROP TABLE IF EXISTS Organization;

--Drop the previous sequences if they exist

DROP SEQUENCE IF EXISTS Organization_seq;
DROP SEQUENCE IF EXISTS Site_seq;
DROP SEQUENCE IF EXISTS LanSupernet_seq;
DROP SEQUENCE IF EXISTS LanSubnet_seq;
DROP SEQUENCE IF EXISTS DhcpScope_seq;
DROP SEQUENCE IF EXISTS DhcpReservation_seq;
DROP SEQUENCE IF EXISTS Host_seq;
DROP SEQUENCE IF EXISTS Template_seq;
DROP SEQUENCE IF EXISTS Device_seq;
DROP SEQUENCE IF EXISTS Interface_seq;
DROP SEQUENCE IF EXISTS InternetConnection_seq;
DROP SEQUENCE IF EXISTS HostIpAddressHistory_seq 

--Create the new tables
GO
CREATE TABLE Organization (
    organizationId INT NOT NULL PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    description    VARCHAR(255) NULL
);

CREATE TABLE Template (
    templateId     INT NOT NULL PRIMARY KEY,
    templateName   VARCHAR(100) NOT NULL,
    version        VARCHAR(50) NULL,
    description    VARCHAR(255) NULL
);

CREATE TABLE Site (
    siteId         INT NOT NULL PRIMARY KEY,
    organizationId INT NOT NULL,
    name           VARCHAR(100) NOT NULL,
    region         VARCHAR(50) NULL,
    location       VARCHAR(255) NULL,
    CONSTRAINT FK_Site_Organization
        FOREIGN KEY (organizationId)
        REFERENCES Organization(organizationId)
);

CREATE TABLE LanSupernet (
    lanSupernetId INT NOT NULL PRIMARY KEY,
    siteId        INT NOT NULL,
    cidr          VARCHAR(50) NOT NULL,
    description   VARCHAR(255) NULL,
    CONSTRAINT FK_LanSupernet_Site
        FOREIGN KEY (siteId)
        REFERENCES Site(siteId)
);

CREATE TABLE LanSubnet (
    lanSubnetId    INT NOT NULL PRIMARY KEY,
    lanSupernetId  INT NOT NULL,
    subnetCidr     VARCHAR(32) NOT NULL,
    vlanId         INT NULL,
    gatewayAddress VARCHAR(64) NOT NULL,
    CONSTRAINT FK_LanSubnet_LanSupernet
        FOREIGN KEY (lanSupernetId)
        REFERENCES LanSupernet(lanSupernetId)
);

CREATE TABLE DhcpScope (
    dhcpScopeId       INT NOT NULL PRIMARY KEY,
    lanSubnetId       INT NOT NULL,
    startAddress      VARCHAR(64) NOT NULL,
    endAddress        VARCHAR(64) NOT NULL,
    leaseTimeMinutes  INT NOT NULL,
    CONSTRAINT FK_DhcpScope_LanSubnet
        FOREIGN KEY (lanSubnetId)
        REFERENCES LanSubnet(lanSubnetId)
);

CREATE TABLE Device (
    deviceId          INT NOT NULL PRIMARY KEY,
    siteId            INT NOT NULL,
    name              VARCHAR(64) NOT NULL,
    vendor            VARCHAR(64) NOT NULL,
    model             VARCHAR(64) NULL,
    managementAddress VARCHAR(64) NULL,
    serialNumber      VARCHAR(64) NULL,
    firmwareVersion   VARCHAR(64) NULL,
    installDate       DATE NULL,
    templateId        INT NULL,
	deviceType VARCHAR(16) NOT NULL
    CHECK (deviceType IN ('Router','Switch','Other')),
    CONSTRAINT FK_Device_Site
        FOREIGN KEY (siteId)
        REFERENCES Site(siteId),
    CONSTRAINT FK_Device_Template
        FOREIGN KEY (templateId)
        REFERENCES Template(templateId)
);

CREATE TABLE InternetConnection (
    internetConnectionId INT NOT NULL PRIMARY KEY,
    provider             VARCHAR(128) NOT NULL,
	bandwidthMbps        INT NOT NULL,
    circuitId            VARCHAR(128) NULL,
    connectionCIDR       VARCHAR(64) NOT NULL,
	installDate           DATE NULL
);

CREATE TABLE Interface (
    interfaceId          INT NOT NULL PRIMARY KEY,
    deviceId             INT NOT NULL,
    lanSubnetId          INT NULL,
    internetConnectionId INT NULL,
    name                 VARCHAR(32) NULL,
    interfaceType        VARCHAR(16) NOT NULL,
    adminState           VARCHAR(16) NULL,
    CONSTRAINT FK_Interface_Device
        FOREIGN KEY (deviceId)
        REFERENCES Device(deviceId),
    CONSTRAINT FK_Interface_LanSubnet
        FOREIGN KEY (lanSubnetId)
        REFERENCES LanSubnet(lanSubnetId),
    CONSTRAINT FK_Interface_InternetConnection
        FOREIGN KEY (internetConnectionId)
        REFERENCES InternetConnection(internetConnectionId),
    CONSTRAINT CHK_Interface_Type
        CHECK (interfaceType IN ('LAN','WAN','MGMT'))
);

CREATE TABLE Host (
    hostId      INT NOT NULL PRIMARY KEY,
	interfaceId INT NOT NULL UNIQUE,
    hostName    VARCHAR(128) NULL,
    macAddress  VARCHAR(32) NOT NULL,
    assetTag    VARCHAR(64) NULL,
    ipAddress   VARCHAR(64) NULL,
    CONSTRAINT FK_Host_Interface
        FOREIGN KEY (interfaceId)
        REFERENCES Interface(interfaceId)
);

CREATE TABLE Router (
    deviceId                INT NOT NULL PRIMARY KEY,
    wanFailoverType         VARCHAR(64) NULL,
    advancedSecurityEnabled BIT NOT NULL,
    maxThroughputMbps       INT NOT NULL,
    supportsBgp             BIT NOT NULL,
    redundancyType          VARCHAR(64) NULL,
    CONSTRAINT FK_Router_Device
        FOREIGN KEY (deviceId)
        REFERENCES Device(deviceId)
);

CREATE TABLE Switch (
    deviceId       INT NOT NULL PRIMARY KEY,
    poeSupported   BIT NOT NULL,
    poeBudgetWatts INT NULL,
    stackable      BIT NOT NULL,
    layer3Capable  BIT NOT NULL,
    CONSTRAINT FK_Switch_Device
        FOREIGN KEY (deviceId)
        REFERENCES Device(deviceId)
);

CREATE TABLE DhcpReservation (
    dhcpReservationId INT NOT NULL PRIMARY KEY,
    dhcpScopeId       INT NOT NULL,
    hostId            INT NOT NULL,
    ipAddress         VARCHAR(64) NOT NULL,
    reservationStatus VARCHAR(50) NULL,
    validFrom         DATE NULL,
    validTo           DATE NULL,
    CONSTRAINT FK_DhcpReservation_Scope
        FOREIGN KEY (dhcpScopeId)
        REFERENCES DhcpScope(dhcpScopeId),
    CONSTRAINT FK_DhcpReservation_Host
        FOREIGN KEY (hostId)
        REFERENCES Host(hostId)
);
CREATE TABLE HostIpAddressHistory (
    hostIpAddressHistoryId INT NOT NULL PRIMARY KEY,
    hostId                 INT NOT NULL,
    oldIpAddress           VARCHAR(64) NULL,
    newIpAddress           VARCHAR(64) NULL,
    changeDate             DATETIME NOT NULL,
    CONSTRAINT FK_HostIpAddressHistory_Host
        FOREIGN KEY (hostId)
        REFERENCES Host(hostId)
);
--SEQUENCES
GO
-- Create the new sequences
CREATE SEQUENCE Organization_seq      START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Site_seq              START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE LanSupernet_seq       START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE LanSubnet_seq         START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE DhcpScope_seq         START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE DhcpReservation_seq   START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Host_seq              START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Template_seq          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Device_seq            START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Interface_seq         START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE InternetConnection_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE HostIpAddressHistory_seq START WITH 1 INCREMENT BY 1;


--INDEXES

-- Create indexes for the foreign keys

-- Site → Organization
CREATE NONCLUSTERED INDEX IX_Site_OrganizationId
ON Site (organizationId);

-- LanSupernet → Site
CREATE NONCLUSTERED INDEX IX_LanSupernet_SiteId
ON LanSupernet (siteId);


-- LanSubnet → LanSupernet
CREATE NONCLUSTERED INDEX IX_LanSubnet_LanSupernetId
ON LanSubnet (lanSupernetId);


-- DhcpScope → LanSubnet
CREATE NONCLUSTERED INDEX IX_DhcpScope_LanSubnetId
ON DhcpScope (lanSubnetId);


-- Device → Site
CREATE NONCLUSTERED INDEX IX_Device_SiteId
ON Device (siteId);


-- Device → Template
CREATE NONCLUSTERED INDEX IX_Device_TemplateId
ON Device (templateId);


-- Router → Device
CREATE NONCLUSTERED INDEX IX_Router_DeviceId
ON Router (deviceId);


-- Switch → Device
CREATE NONCLUSTERED INDEX IX_Switch_DeviceId
ON Switch (deviceId);


-- Interface → Device
CREATE NONCLUSTERED INDEX IX_Interface_DeviceId
ON Interface (deviceId);


-- Interface → LanSubnet
CREATE NONCLUSTERED INDEX IX_Interface_LanSubnetId
ON Interface (lanSubnetId);


-- Interface → InternetConnection
CREATE NONCLUSTERED INDEX IX_Interface_InternetConnectionId
ON Interface (internetConnectionId);


-- Host → Interface
CREATE NONCLUSTERED INDEX IX_Host_InterfaceId
ON Host (interfaceId);


-- DhcpReservation → DhcpScope
CREATE NONCLUSTERED INDEX IX_DhcpReservation_DhcpScopeId
ON DhcpReservation (dhcpScopeId);


-- DhcpReservation → Host
CREATE NONCLUSTERED INDEX IX_DhcpReservation_HostId
ON DhcpReservation (hostId);

-- Three Non-key indexes
CREATE NONCLUSTERED INDEX IX_Interface_Name
ON Interface (name);

CREATE NONCLUSTERED INDEX IX_Device_Name
ON Device (name);

CREATE NONCLUSTERED INDEX IX_LanSubnet_SubnetCidr
ON LanSubnet (subnetCidr);


--STORED PROCEDURES
GO
CREATE OR ALTER PROCEDURE AddOrganization
    @organizationName VARCHAR(255),
    @organizationDescription VARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @newOrgId INT;
    SET @newOrgId = NEXT VALUE FOR Organization_seq;
    INSERT INTO Organization (
        organizationId,
        name,
		
        description
    )
    VALUES (
        @newOrgId,
        @organizationName,
        @organizationDescription
    );
END;
GO

CREATE OR ALTER PROCEDURE AddSiteWithSupernet
    @organizationName VARCHAR(255),
    @siteName         VARCHAR(100),
    @region           VARCHAR(50)  = NULL,
    @location         VARCHAR(255) = NULL,
    @supernetCidr     VARCHAR(50),
    @supernetDesc     VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @organizationId   INT;
    DECLARE @newSiteId        INT;
    DECLARE @newLanSupernetId INT;

    -- Lookup OrganizationId based on name

    SELECT @organizationId = organizationId
    FROM   Organization
    WHERE  name = @organizationName;

    IF @organizationId IS NULL
    BEGIN
        RAISERROR('Organization not found: %s', 16, 1, @organizationName);
        RETURN;
    END
  
    -- Generate surrogate keys
    SET @newSiteId        = NEXT VALUE FOR Site_seq;
    SET @newLanSupernetId = NEXT VALUE FOR LanSupernet_seq;

    -- Insert the new Site

    INSERT INTO Site (
        siteId,
        organizationId,
        name,
        region,
        location
    )
    VALUES (
        @newSiteId,
        @organizationId,
        @siteName,
        @region,
        @location
    );

    -- Insert the associated LAN Supernet

    INSERT INTO LanSupernet (
        lanSupernetId,
        siteId,
        cidr,
        description
    )
    VALUES (
        @newLanSupernetId,
        @newSiteId,
        @supernetCidr,
        @supernetDesc
    );
END;
GO


CREATE OR ALTER PROCEDURE AddSubnet
    @organizationName VARCHAR(255),
    @siteName         VARCHAR(255),
    @subnetCidr       VARCHAR(32),
    @vlanId           INT          = NULL,
    @gatewayAddress   VARCHAR(64),
    @startAddress     VARCHAR(64) = NULL,   -- Optional
    @endAddress       VARCHAR(64) = NULL,   -- Optional
    @leaseTimeMinutes INT          = NULL   -- Optional, required only if DHCP is created
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @organizationId INT;
    DECLARE @lanSupernetId  INT;
    DECLARE @newLanSubnetId INT;
    DECLARE @newDhcpScopeId INT;

    -- Resolve Organization ID from name
    SELECT @organizationId = organizationId
    FROM   Organization
    WHERE  name = @organizationName;

    IF @organizationId IS NULL
    BEGIN
        RAISERROR('Organization not found: %s', 16, 1, @organizationName);
        RETURN;
    END

    -- Resolve LAN Supernet associated with this organization's site

    SELECT @lanSupernetId = ls.lanSupernetId
    FROM   LanSupernet AS ls
    JOIN   Site        AS s  ON s.siteId = ls.siteId
    WHERE  s.name = @siteName
      AND  s.organizationId = @organizationId;

    IF @lanSupernetId IS NULL
    BEGIN
        RAISERROR('No LAN Supernet found for site %s in organization %s',
                  16, 1, @siteName, @organizationName);
        RETURN;
    END

  
    -- Generate surrogate key for LAN Subnet

    SET @newLanSubnetId = NEXT VALUE FOR LanSubnet_seq;

    -- Insert LAN Subnet

    INSERT INTO LanSubnet (
        lanSubnetId,
        lanSupernetId,
        subnetCidr,
        vlanId,
        gatewayAddress
    )
    VALUES (
        @newLanSubnetId,
        @lanSupernetId,
        @subnetCidr,
        @vlanId,
        @gatewayAddress
    );


    -- Optional DHCP Scope creation

    IF @startAddress IS NOT NULL AND @endAddress IS NOT NULL
    BEGIN
        IF @leaseTimeMinutes IS NULL
        BEGIN
            RAISERROR('leaseTimeMinutes must be provided when creating a DHCP scope.', 
                      16, 1);
            RETURN;
        END

        -- Generate surrogate key for DHCP Scope
        SET @newDhcpScopeId = NEXT VALUE FOR DhcpScope_seq;

        INSERT INTO DhcpScope (
            dhcpScopeId,
            lanSubnetId,
            startAddress,
            endAddress,
            leaseTimeMinutes
        )
        VALUES (
            @newDhcpScopeId,
            @newLanSubnetId,
            @startAddress,
            @endAddress,
            @leaseTimeMinutes
        );
    END
END;
GO

--TRIGGERS

-- 13.4.2 - Trigger Implementation 

CREATE OR ALTER TRIGGER HostIpAddressHistoryInsertTrigger
ON Host
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Capture initial IP assignment when a Host is created
    INSERT INTO HostIpAddressHistory (
        hostIpAddressHistoryId,
        hostId,
        oldIpAddress,
        newIpAddress,
        changeDate
    )
    SELECT
        NEXT VALUE FOR HostIpAddressHistory_seq,
        inserted.hostId,
        NULL AS oldIpAddress,
        inserted.ipAddress AS newIpAddress,
        GETDATE()
    FROM inserted
    WHERE inserted.ipAddress IS NOT NULL;     -- Only record meaningful entries
END;

GO
CREATE OR ALTER TRIGGER HostIpAddressHistoryTrigger
ON Host
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert a history row for every Host whose IP address changes
    INSERT INTO HostIpAddressHistory (
        hostIpAddressHistoryId,
        hostId,
        oldIpAddress,
        newIpAddress,
        changeDate
    )
    SELECT
        NEXT VALUE FOR HostIpAddressHistory_seq,
        deleted.hostId,
        deleted.ipAddress AS oldIpAddress,
        inserted.ipAddress AS newIpAddress,
        GETDATE()
    FROM inserted
    JOIN deleted 
        ON inserted.hostId = deleted.hostId
    WHERE
           (deleted.ipAddress IS NULL AND inserted.ipAddress IS NOT NULL)
        OR (deleted.ipAddress IS NOT NULL AND inserted.ipAddress IS NULL)
        OR (deleted.ipAddress IS NOT NULL AND inserted.ipAddress IS NOT NULL AND deleted.ipAddress <> inserted.ipAddress);
END;

--QUERIES
/* ============================================================
This will create seed data to use in our database. This seed data was AI created and modified by Michael Bohen

We are performing the following steps.

0. Deleting the existing data in the tables to begin from a clean starting point.
1. Creating variables to use in the remainder of the script. This allows us to avoid hard coding values and avoid excessive table lookups.
2. Creating the organization
3. Creating the sites and supernets. We will be creating 5 sites.
4. Creating the subnets. We are creating 3 subnets in the Boston site and 2 subnets in the Sydney site
5. Creating 2 device TEMPLATES
6. Creating a switch and a router in each Site
7. Adding the specialization attributes for each device
8. Creating 2 Internet CONNECTIONS
9. Creating a WAN and LAN interface in each Site
10. Creating 5 switchports for use in Boston
11. Creating 5 hosts residing in Boston
12. Creating 4 switchports for use in Sydney
13. Creating 4 hosts residing in Sydney
14. Creating DHCP reservations
   ============================================================ */
GO
---------------------------------------------------------------
-- 0. DELETE EXISTING ROWS.
---------------------------------------------------------------
DELETE FROM DhcpReservation;
DELETE FROM Host;
DELETE FROM Interface;
DELETE FROM InternetConnection;
DELETE FROM Router;
DELETE FROM Switch;
DELETE FROM Device;
DELETE FROM Template;
DELETE FROM DhcpScope;
DELETE FROM LanSubnet;
DELETE FROM LanSupernet;
DELETE FROM Site;
DELETE FROM Organization;

---------------------------------------------------------------
-- 1. DECLARE VARIABLES FOR MAJOR ENTITIES
---------------------------------------------------------------
DECLARE @OrgId INT;

DECLARE @BostonSiteId INT;
DECLARE @NewYorkSiteId INT;
DECLARE @DublinSiteId INT;
DECLARE @SaoPauloSiteId INT;
DECLARE @SydneySiteId INT;

DECLARE @BostonSubnet10Id INT;
DECLARE @BostonSubnet20Id INT;
DECLARE @BostonSubnet30Id INT;

DECLARE @SydneySubnet10Id INT;
DECLARE @SydneySubnet20Id INT;

DECLARE @BranchRouterTemplateId INT;
DECLARE @AccessSwitchTemplateId INT;

DECLARE @BostonRouterId INT;
DECLARE @BostonSwitchId INT;

DECLARE @SydneyRouterId INT;
DECLARE @SydneySwitchId INT;

DECLARE @BostonInternetConnectionId INT;
DECLARE @SydneyInternetConnectionId INT;

DECLARE @BostonRouterWanInterfaceId INT;
DECLARE @SydneyRouterWanInterfaceId INT;

DECLARE @BostonRouterLanInterfaceId INT;
DECLARE @SydneyRouterLanInterfaceId INT;

DECLARE @BostonSwitchPort1InterfaceId INT;
DECLARE @BostonSwitchPort2InterfaceId INT;
DECLARE @BostonSwitchPort3InterfaceId INT;
DECLARE @BostonSwitchPort4InterfaceId INT;
DECLARE @BostonSwitchPort5InterfaceId INT;

DECLARE @SydneySwitchPort1InterfaceId INT;
DECLARE @SydneySwitchPort2InterfaceId INT;
DECLARE @SydneySwitchPort3InterfaceId INT;
DECLARE @SydneySwitchPort4InterfaceId INT;

DECLARE @BostonSubnet10ScopeId INT;

---------------------------------------------------------------
-- 2. ORGANIZATION
---------------------------------------------------------------
EXEC AddOrganization
    @organizationName        = 'BlueSkyCorporate',
    @organizationDescription = 'Primary global organization for BlueSky IPAM data';

SELECT @OrgId = Organization.organizationId
FROM Organization
WHERE Organization.name = 'BlueSkyCorporate';

---------------------------------------------------------------
-- 3. SITES + SUPERNETS
---------------------------------------------------------------
EXEC AddSiteWithSupernet
    @organizationName = 'BlueSkyCorporate',
    @siteName         = 'Boston HQ',
    @region           = 'NA',
    @location         = 'Boston, MA',
    @supernetCidr     = '10.10.0.0/16',
    @supernetDesc     = 'Boston HQ primary LAN supernet';

EXEC AddSiteWithSupernet
    @organizationName = 'BlueSkyCorporate',
    @siteName         = 'New York Office',
    @region           = 'NA',
    @location         = 'New York, NY',
    @supernetCidr     = '10.11.0.0/16',
    @supernetDesc     = 'New York Office primary LAN supernet';

EXEC AddSiteWithSupernet
    @organizationName = 'BlueSkyCorporate',
    @siteName         = 'Dublin DC',
    @region           = 'EMEA',
    @location         = 'Dublin, Ireland',
    @supernetCidr     = '10.12.0.0/16',
    @supernetDesc     = 'Dublin data center LAN supernet';

EXEC AddSiteWithSupernet
    @organizationName = 'BlueSkyCorporate',
    @siteName         = 'São Paulo Office',
    @region           = 'LATAM',
    @location         = 'São Paulo, Brazil',
    @supernetCidr     = '10.13.0.0/16',
    @supernetDesc     = 'São Paulo primary LAN supernet';

EXEC AddSiteWithSupernet
    @organizationName = 'BlueSkyCorporate',
    @siteName         = 'Sydney Office',
    @region           = 'APAC',
    @location         = 'Sydney, Australia',
    @supernetCidr     = '10.20.0.0/16',
    @supernetDesc     = 'Sydney primary LAN supernet';

SELECT @BostonSiteId   = Site.siteId FROM Site WHERE Site.name = 'Boston HQ';
SELECT @NewYorkSiteId  = Site.siteId FROM Site WHERE Site.name = 'New York Office';
SELECT @DublinSiteId   = Site.siteId FROM Site WHERE Site.name = 'Dublin DC';
SELECT @SaoPauloSiteId = Site.siteId FROM Site WHERE Site.name = 'São Paulo Office';
SELECT @SydneySiteId   = Site.siteId FROM Site WHERE Site.name = 'Sydney Office';

---------------------------------------------------------------
-- 4. SUBNETS (WITH DHCP SCOPES WHERE APPLICABLE)
---------------------------------------------------------------
-- Boston subnets
EXEC AddSubnet
    @organizationName = 'BlueSkyCorporate',
    @siteName         = 'Boston HQ',
    @subnetCidr       = '10.10.10.0/24',
    @vlanId           = 10,
    @gatewayAddress   = '10.10.10.1',
    @startAddress     = '10.10.10.100',
    @endAddress       = '10.10.10.200',
    @leaseTimeMinutes = 1440;

EXEC AddSubnet
    @organizationName = 'BlueSkyCorporate',
    @siteName         = 'Boston HQ',
    @subnetCidr       = '10.10.20.0/24',
    @vlanId           = 20,
    @gatewayAddress   = '10.10.20.1',
    @startAddress     = '10.10.20.50',
    @endAddress       = '10.10.20.150',
    @leaseTimeMinutes = 480;

EXEC AddSubnet
    @organizationName = 'BlueSkyCorporate',
    @siteName         = 'Boston HQ',
    @subnetCidr       = '10.10.30.0/24',
    @vlanId           = 30,
    @gatewayAddress   = '10.10.30.1',
    @startAddress     = NULL,
    @endAddress       = NULL,
    @leaseTimeMinutes = NULL;

-- Sydney subnets
EXEC AddSubnet
    @organizationName = 'BlueSkyCorporate',
    @siteName         = 'Sydney Office',
    @subnetCidr       = '10.20.10.0/24',
    @vlanId           = 10,
    @gatewayAddress   = '10.20.10.1',
    @startAddress     = '10.20.10.100',
    @endAddress       = '10.20.10.200',
    @leaseTimeMinutes = 1440;

EXEC AddSubnet
    @organizationName = 'BlueSkyCorporate',
    @siteName         = 'Sydney Office',
    @subnetCidr       = '10.20.20.0/24',
    @vlanId           = 20,
    @gatewayAddress   = '10.20.20.1',
    @startAddress     = NULL,
    @endAddress       = NULL,
    @leaseTimeMinutes = NULL;

SELECT @BostonSubnet10Id = LanSubnet.lanSubnetId FROM LanSubnet WHERE LanSubnet.subnetCidr = '10.10.10.0/24';
SELECT @BostonSubnet20Id = LanSubnet.lanSubnetId FROM LanSubnet WHERE LanSubnet.subnetCidr = '10.10.20.0/24';
SELECT @BostonSubnet30Id = LanSubnet.lanSubnetId FROM LanSubnet WHERE LanSubnet.subnetCidr = '10.10.30.0/24';

SELECT @SydneySubnet10Id = LanSubnet.lanSubnetId FROM LanSubnet WHERE LanSubnet.subnetCidr = '10.20.10.0/24';
SELECT @SydneySubnet20Id = LanSubnet.lanSubnetId FROM LanSubnet WHERE LanSubnet.subnetCidr = '10.20.20.0/24';

---------------------------------------------------------------
-- 5. TEMPLATES
---------------------------------------------------------------
INSERT INTO Template (templateId, templateName, version, description)
VALUES (NEXT VALUE FOR Template_seq, 'BranchRouterTemplate','v1.0','Standard MX branch router configuration');

INSERT INTO Template (templateId, templateName, version, description)
VALUES (NEXT VALUE FOR Template_seq, 'AccessSwitchTemplate','v1.0','Standard access switch template with PoE');

SELECT @BranchRouterTemplateId = Template.templateId
FROM Template WHERE Template.templateName = 'BranchRouterTemplate';

SELECT @AccessSwitchTemplateId = Template.templateId
FROM Template WHERE Template.templateName = 'AccessSwitchTemplate';

---------------------------------------------------------------
-- 6. DEVICES (ROUTERS & SWITCHES)
---------------------------------------------------------------
-- Boston router
INSERT INTO Device (
    deviceId, siteId, name, vendor, model, managementAddress,
    serialNumber, firmwareVersion, installDate, templateId, deviceType
)
VALUES (
    NEXT VALUE FOR Device_seq,
	@BostonSiteId,
    'BOS-MX100-1',
    'Cisco Meraki',
    'MX100',
    '10.10.0.1',
    'BOS-MX100-1-SN',
    'mx-fw-18.0',
    '2023-01-15',
    @BranchRouterTemplateId,
	'Router'
	
);

SELECT @BostonRouterId = Device.deviceId
FROM Device WHERE Device.name = 'BOS-MX100-1';

-- Boston switch
INSERT INTO Device (
    deviceId, siteId, name, vendor, model, managementAddress,
    serialNumber, firmwareVersion, installDate, templateId, deviceType
)
VALUES (
    NEXT VALUE FOR Device_seq,
	@BostonSiteId,
    'BOS-MS225-1',
    'Cisco Meraki',
    'MS225-48FP',
    '10.10.0.11',
    'BOS-MS225-1-SN',
    'ms-fw-14.1',
    '2023-02-01',
    @AccessSwitchTemplateId,
	'Switch'
);

SELECT @BostonSwitchId = Device.deviceId
FROM Device WHERE Device.name = 'BOS-MS225-1';

-- Sydney router
INSERT INTO Device (
    deviceId, siteId, name, vendor, model, managementAddress,
    serialNumber, firmwareVersion, installDate, templateId, deviceType
)
VALUES (
    NEXT VALUE FOR Device_seq,
	@SydneySiteId,
    'SYD-MX95-1',
    'Cisco Meraki',
    'MX95',
    '10.20.0.1',
    'SYD-MX95-1-SN',
    'mx-fw-18.0',
    '2023-03-10',
    @BranchRouterTemplateId,
	'Router'
);

SELECT @SydneyRouterId = Device.deviceId
FROM Device WHERE Device.name = 'SYD-MX95-1';

-- Sydney switch
INSERT INTO Device (
    deviceId, siteId, name, vendor, model, managementAddress,
    serialNumber, firmwareVersion, installDate, templateId, deviceType
)
VALUES (
    NEXT VALUE FOR Device_seq,
	@SydneySiteId,
    'SYD-MS225-1',
    'Cisco Meraki',
    'MS225-48FP',
    '10.20.0.11',
    'SYD-MS225-1-SN',
    'ms-fw-14.1',
    '2023-03-20',
    @AccessSwitchTemplateId,
	'Switch'
);

SELECT @SydneySwitchId = Device.deviceId
FROM Device WHERE Device.name = 'SYD-MS225-1';

---------------------------------------------------------------
-- 7. SPECIALIZATION ROWS (ROUTER / SWITCH)
---------------------------------------------------------------
INSERT INTO Router (
    deviceId,
    wanFailoverType,
    advancedSecurityEnabled,
    maxThroughputMbps,
    supportsBgp,
    redundancyType
)
VALUES (
    @BostonRouterId,
    'Dual-WAN',
    1,
    1000,
    1,
    'HA pair'
);

INSERT INTO Switch (
    deviceId,
    poeSupported,
    poeBudgetWatts,
    stackable,
    layer3Capable
)
VALUES (
    @BostonSwitchId,
    1,
    740,
    1,
    1
);

INSERT INTO Router (
    deviceId,
    wanFailoverType,
    advancedSecurityEnabled,
    maxThroughputMbps,
    supportsBgp,
    redundancyType
)
VALUES (
    @SydneyRouterId,
    'Single-WAN',
    1,
    750,
    0,
    'Standalone'
);

INSERT INTO Switch (
    deviceId,
    poeSupported,
    poeBudgetWatts,
    stackable,
    layer3Capable
)
VALUES (
    @SydneySwitchId,
    1,
    740,
    1,
    0
);

---------------------------------------------------------------
-- 8. INTERNET CONNECTIONS
---------------------------------------------------------------
INSERT INTO InternetConnection (
    internetConnectionId,
	provider,
    bandwidthMbps,
    circuitId,
    connectionCIDR,
    installDate
)
VALUES (
    NEXT VALUE FOR InternetConnection_seq,
	'NextHop ISP',
    500,
    'NH-BOS-001',
    '198.51.100.24/30',
    '2023-01-10'
);

INSERT INTO InternetConnection (
    internetConnectionId,
	provider,
    bandwidthMbps,
    circuitId,
    connectionCIDR,
    installDate
)
VALUES (
    NEXT VALUE FOR InternetConnection_seq,
	'NextHop ISP',
    300,
    'NH-SYD-001',
    '203.0.113.40/30',
    '2023-03-05'
);

SELECT @BostonInternetConnectionId = InternetConnection.internetConnectionId
FROM InternetConnection WHERE InternetConnection.circuitId = 'NH-BOS-001';

SELECT @SydneyInternetConnectionId = InternetConnection.internetConnectionId
FROM InternetConnection WHERE InternetConnection.circuitId = 'NH-SYD-001';

---------------------------------------------------------------
-- 9. ROUTER INTERFACES (WAN + LAN GATEWAY)
---------------------------------------------------------------
-- Boston WAN
INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
	NEXT VALUE FOR Interface_seq,
    @BostonRouterId,
    NULL,
    @BostonInternetConnectionId,
    'wan1',
    'WAN',
    'UP'
);

SELECT @BostonRouterWanInterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @BostonRouterId AND Interface.name = 'wan1';

-- Sydney WAN
INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
    @SydneyRouterId,
    NULL,
    @SydneyInternetConnectionId,
    'wan1',
    'WAN',
    'UP'
);

SELECT @SydneyRouterWanInterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @SydneyRouterId AND Interface.name = 'wan1';

-- Boston LAN gateway
INSERT INTO Interface (
	interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
    @BostonRouterId,
    @BostonSubnet10Id,
    NULL,
    'lan-gw',
    'LAN',
    'UP'
);

SELECT @BostonRouterLanInterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @BostonRouterId AND Interface.name = 'lan-gw';

-- Sydney LAN gateway
INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
	@SydneyRouterId,
    @SydneySubnet10Id,
    NULL,
    'lan-gw',
    'LAN',
    'UP'
);

SELECT @SydneyRouterLanInterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @SydneyRouterId AND Interface.name = 'lan-gw';

---------------------------------------------------------------
-- 10. BOSTON SWITCH PORTS (port1–port5)
---------------------------------------------------------------
INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
	@BostonSwitchId,
    @BostonSubnet10Id,
    NULL,
    'port1',
    'LAN',
    'UP'
);

SELECT @BostonSwitchPort1InterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @BostonSwitchId AND Interface.name = 'port1';

INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
	@BostonSwitchId,
    @BostonSubnet10Id,
    NULL,
    'port2',
    'LAN',
    'UP'
);

SELECT @BostonSwitchPort2InterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @BostonSwitchId AND Interface.name = 'port2';

INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
	@BostonSwitchId,
    @BostonSubnet10Id,
    NULL,
    'port3',
    'LAN',
    'UP'
);

SELECT @BostonSwitchPort3InterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @BostonSwitchId AND Interface.name = 'port3';

INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
	@BostonSwitchId,
    @BostonSubnet10Id,
    NULL,
    'port4',
    'LAN',
    'UP'
);

SELECT @BostonSwitchPort4InterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @BostonSwitchId AND Interface.name = 'port4';

INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
	@BostonSwitchId,
    @BostonSubnet10Id,
    NULL,
    'port5',
    'LAN',
    'UP'
);

SELECT @BostonSwitchPort5InterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @BostonSwitchId AND Interface.name = 'port5';

---------------------------------------------------------------
-- 11. BOSTON HOSTS (5 HOSTS)
---------------------------------------------------------------
INSERT INTO Host (
    hostId,
	interfaceId,
    hostName,
    macAddress,
    assetTag,
    ipAddress
)
VALUES (
    NEXT VALUE FOR Host_seq,
	@BostonSwitchPort1InterfaceId,
    'bos-host-01',
    'AA-BB-CC-DD-EE-01',
    'BOS-HOST-01',
    '10.10.10.101'
);

INSERT INTO Host (
    hostId,
	interfaceId,
    hostName,
    macAddress,
    assetTag,
    ipAddress
)
VALUES (
    NEXT VALUE FOR Host_seq,
	@BostonSwitchPort2InterfaceId,
    'bos-host-02',
    'AA-BB-CC-DD-EE-02',
    'BOS-HOST-02',
    '10.10.10.102'
);

INSERT INTO Host (
    hostId,
	interfaceId,
    hostName,
    macAddress,
    assetTag,
    ipAddress
)
VALUES (
    NEXT VALUE FOR Host_seq,
	@BostonSwitchPort3InterfaceId,
    'bos-host-03',
    'AA-BB-CC-DD-EE-03',
    'BOS-HOST-03',
    '10.10.10.103'
);

INSERT INTO Host (
    hostId,
	interfaceId,
    hostName,
    macAddress,
    assetTag,
    ipAddress
)
VALUES (
    NEXT VALUE FOR Host_seq,
	@BostonSwitchPort4InterfaceId,
    'bos-host-04',
    'AA-BB-CC-DD-EE-04',
    'BOS-HOST-04',
    '10.10.10.104'
);

INSERT INTO Host (
    hostId,
	interfaceId,
    hostName,
    macAddress,
    assetTag,
    ipAddress
)
VALUES (
    NEXT VALUE FOR Host_seq,
	@BostonSwitchPort5InterfaceId,
    'bos-host-05',
    'AA-BB-CC-DD-EE-05',
    'BOS-HOST-05',
    '10.10.10.105'
);

---------------------------------------------------------------
-- 12. SYDNEY SWITCH PORTS (port1–port4)
---------------------------------------------------------------
INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
	@SydneySwitchId,
    @SydneySubnet10Id,
    NULL,
    'port1',
    'LAN',
    'UP'
);

SELECT @SydneySwitchPort1InterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @SydneySwitchId AND Interface.name = 'port1';

INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
	@SydneySwitchId,
    @SydneySubnet10Id,
    NULL,
    'port2',
    'LAN',
    'UP'
);

SELECT @SydneySwitchPort2InterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @SydneySwitchId AND Interface.name = 'port2';

INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
	@SydneySwitchId,
    @SydneySubnet10Id,
    NULL,
    'port3',
    'LAN',
    'UP'
);

SELECT @SydneySwitchPort3InterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @SydneySwitchId AND Interface.name = 'port3';

INSERT INTO Interface (
    interfaceId,
	deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    NEXT VALUE FOR Interface_seq,
	@SydneySwitchId,
    @SydneySubnet10Id,
    NULL,
    'port4',
    'LAN',
    'UP'
);

SELECT @SydneySwitchPort4InterfaceId = Interface.interfaceId
FROM Interface
WHERE Interface.deviceId = @SydneySwitchId AND Interface.name = 'port4';

---------------------------------------------------------------
-- 13. SYDNEY HOSTS (4 HOSTS)
---------------------------------------------------------------
INSERT INTO Host (
    hostId,
	interfaceId,
    hostName,
    macAddress,
    assetTag,
    ipAddress
)
VALUES (
    NEXT VALUE FOR Host_seq,
	@SydneySwitchPort1InterfaceId,
    'syd-host-01',
    'AA-BB-CC-DD-EE-11',
    'SYD-HOST-01',
    '10.20.10.101'
);

INSERT INTO Host (
    hostId,
	interfaceId,
    hostName,
    macAddress,
    assetTag,
    ipAddress
)
VALUES (
    NEXT VALUE FOR Host_seq,
	@SydneySwitchPort2InterfaceId,
    'syd-host-02',
    'AA-BB-CC-DD-EE-12',
    'SYD-HOST-02',
    '10.20.10.102'
);

INSERT INTO Host (
    hostId,
	interfaceId,
    hostName,
    macAddress,
    assetTag,
    ipAddress
)
VALUES (
    NEXT VALUE FOR Host_seq,
	@SydneySwitchPort3InterfaceId,
    'syd-host-03',
    'AA-BB-CC-DD-EE-13',
    'SYD-HOST-03',
    '10.20.10.103'
);

INSERT INTO Host (
    hostId,
	interfaceId,
    hostName,
    macAddress,
    assetTag,
    ipAddress
)
VALUES (
    NEXT VALUE FOR Host_seq,
	@SydneySwitchPort4InterfaceId,
    'syd-host-04',
    'AA-BB-CC-DD-EE-14',
    'SYD-HOST-04',
    '10.20.10.104'
);

---------------------------------------------------------------
-- 14. DHCP RESERVATION (EXAMPLE)
---------------------------------------------------------------
SELECT @BostonSubnet10ScopeId = DhcpScope.dhcpScopeId
FROM DhcpScope
WHERE DhcpScope.lanSubnetId = @BostonSubnet10Id;

INSERT INTO DhcpReservation (
    dhcpReservationId,
	dhcpScopeId,
    hostId,
    ipAddress,
    reservationStatus,
    validFrom,
    validTo
)
VALUES (
    NEXT VALUE FOR DhcpReservation_seq,
	@BostonSubnet10ScopeId,
    (SELECT Host.hostId FROM Host WHERE Host.hostName = 'bos-host-01'),
    '10.10.10.101',
    'ACTIVE',
    '2023-06-01',
    NULL
);

-- Query 1 (Described in section 11.2)
SELECT
    Organization.name AS organizationName,
    Site.name AS siteName,
    Host.hostName,
    Host.macAddress,
    Host.assetTag,
    Host.ipAddress,
    Device.name AS switchName,
    Interface.name AS switchPort,
    LanSubnet.subnetCidr AS lanSubnet
FROM Host
JOIN Interface
    ON Host.interfaceId = Interface.interfaceId
JOIN Device
    ON Interface.deviceId = Device.deviceId
JOIN LanSubnet
    ON Interface.lanSubnetId = LanSubnet.lanSubnetId
JOIN Site
    ON Device.siteId = Site.siteId
JOIN Organization
    ON Site.organizationId = Organization.organizationId
ORDER BY
    Site.name,
    Host.hostName;


-- Query 2 (Described in Section 11.3)
SELECT
    Device.deviceId,
    Device.name,
    Device.deviceType,
    Site.name AS SiteName,
    Router.wanFailoverType,
    Router.advancedSecurityEnabled,
    Router.maxThroughputMbps,
    Router.supportsBgp,
    Router.redundancyType,
    Switch.poeSupported,
    Switch.poeBudgetWatts,
    Switch.stackable,
    Switch.layer3Capable
FROM Device
JOIN Site
    ON Device.siteId = Site.siteId
LEFT JOIN Router
    ON Device.deviceId = Router.deviceId
   AND Device.deviceType = 'Router'
LEFT JOIN Switch
    ON Device.deviceId = Switch.deviceId
   AND Device.deviceType = 'Switch'
ORDER BY Device.deviceType, Device.deviceId;

-- View and Query 3 (Described in Section 11.4)

DROP VIEW IF EXISTS vSubnetHostCounts -- Added to allow this script to run multiple times
GO
CREATE VIEW vSubnetHostCounts AS -- Create a view vSubnetHostCounts
SELECT
    Site.name AS siteName,
    LanSubnet.subnetCidr,
    COUNT(Host.hostId) AS hostCount
FROM LanSubnet
JOIN LanSupernet
    ON LanSubnet.lanSupernetId = LanSupernet.lanSupernetId
JOIN Site
    ON LanSupernet.siteId = Site.siteId
LEFT JOIN Interface
    ON Interface.lanSubnetId = LanSubnet.lanSubnetId
LEFT JOIN Host
    ON Host.interfaceId = Interface.interfaceId
GROUP BY
    Site.name,
    LanSubnet.subnetCidr;
GO -- Use vSubnetHostCounts to retrieve the host counts of all subnets that have >0 hosts
SELECT
    vSubnetHostCounts.siteName,
    vSubnetHostCounts.subnetCidr,
    vSubnetHostCounts.hostCount
FROM vSubnetHostCounts
WHERE vSubnetHostCounts.hostCount > 0
ORDER BY vSubnetHostCounts.hostCount DESC;

-- These queries represent the verifications of the HostIpAddressHistory table presented in Section 13.5

-- 13.5.0 Prepare an interface for the demonstration.

DECLARE @SydneySwitchId INT = (
    SELECT deviceId FROM Device WHERE name = 'SYD-MS225-1'
);

DECLARE @SydneySubnet10Id INT = (
    SELECT lanSubnetId FROM LanSubnet WHERE subnetCidr = '10.20.10.0/24'
);

DECLARE @SydneySwitchPort5InterfaceId INT = NEXT VALUE FOR Interface_seq;

INSERT INTO Interface (
    interfaceId,
    deviceId,
    lanSubnetId,
    internetConnectionId,
    name,
    interfaceType,
    adminState
)
VALUES (
    @SydneySwitchPort5InterfaceId,
    @SydneySwitchId,
    @SydneySubnet10Id,
    NULL,
    'port5',
    'LAN',
    'UP');


-- 13.5.1 Create a Host for Demonstration
DECLARE @testHostId INT = NEXT VALUE FOR Host_seq;

INSERT INTO Host (
    hostId,
    interfaceId,
    hostName,
    macAddress,
    assetTag,
    ipAddress
)
VALUES (
    @testHostId,
    @SydneySwitchPort5InterfaceId,
    'history-test-host',
    'AA-BB-CC-DD-EE-99',
    'HIST-TEST-001',
    '10.20.10.150'
);

-- 13.5.2 Generate IP Address Changes

UPDATE Host SET ipAddress = '10.20.10.175' WHERE hostName = 'history-test-host';
UPDATE Host SET ipAddress = '10.20.10.200' WHERE hostName = 'history-test-host';
UPDATE Host SET ipAddress = NULL           WHERE hostName = 'history-test-host';
UPDATE Host SET ipAddress = '10.20.10.225' WHERE hostName = 'history-test-host';

-- 13.5.3 View Recorded History
SELECT
    hostIpAddressHistoryId,
    hostId,
    oldIpAddress,
    newIpAddress,
    changeDate
FROM HostIpAddressHistory
WHERE hostId = (
    SELECT hostId FROM Host WHERE hostName = 'history-test-host'
)
ORDER BY hostIpAddressHistoryId;


-- 14.1 Adding Synthetic History Data
-------------------------------------------------------------
-- SYNTHETIC HISTORY FOR VISUALIZATION (Boston vs Sydney)
-- Boston: Light churn (6 days)
-- Sydney: Heavy, irregular churn (14 days)
-- All dates in November 2025
-------------------------------------------------------------

PRINT '--- Generating enhanced synthetic history data for Visualization 1 ---';

-------------------------------------------------------------
-- 1. Clear older synthetic history for these two hosts
-------------------------------------------------------------
DELETE FROM HostIpAddressHistory
WHERE hostId IN (
    SELECT hostId FROM Host
    WHERE hostName IN ('bos-host-01','syd-host-01')
);

-------------------------------------------------------------
-- 2. Retrieve host IDs
-------------------------------------------------------------
DECLARE @bosHostId INT;
DECLARE @sydHostId INT;

SELECT @bosHostId = hostId FROM Host WHERE hostName = 'bos-host-01';
SELECT @sydHostId = hostId FROM Host WHERE hostName = 'syd-host-01';

-------------------------------------------------------------
-- 3. Boston: Low, steady churn across November 2025
-------------------------------------------------------------
INSERT INTO HostIpAddressHistory VALUES
    (NEXT VALUE FOR HostIpAddressHistory_seq, @bosHostId, '10.10.10.101', '10.10.10.111', '2025-11-02'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @bosHostId, '10.10.10.111', '10.10.10.112', '2025-11-05'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @bosHostId, '10.10.10.112', '10.10.10.113', '2025-11-10'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @bosHostId, '10.10.10.113', '10.10.10.114', '2025-11-15'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @bosHostId, '10.10.10.114', '10.10.10.115', '2025-11-22'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @bosHostId, '10.10.10.115', '10.10.10.116', '2025-11-28');

-------------------------------------------------------------
-- 4. Sydney: Higher, irregular churn across the same month
-------------------------------------------------------------
-- Early November burst
INSERT INTO HostIpAddressHistory VALUES
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.101', '10.20.10.201', '2025-11-01'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.201', '10.20.10.202', '2025-11-01'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.202', '10.20.10.203', '2025-11-02'),

-- Mid-November spike (visual peak)
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.203', '10.20.10.204', '2025-11-10'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.204', '10.20.10.205', '2025-11-10'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.205', '10.20.10.206', '2025-11-10'),

-- Irregular changes throughout month
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.206', '10.20.10.207', '2025-11-14'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.207', '10.20.10.208', '2025-11-17'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.208', '10.20.10.209', '2025-11-18'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.209', '10.20.10.210', '2025-11-22'),

-- End-of-month flurry
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.210', '10.20.10.211', '2025-11-28'),
    (NEXT VALUE FOR HostIpAddressHistory_seq, @sydHostId, '10.20.10.211', '10.20.10.212', '2025-11-30');

PRINT '--- Enhanced synthetic churn creation complete ---';


-- 14.1 Displaying Updated hostIpAddressHistoryId Table showing all hosts
SELECT
    hostIpAddressHistoryId,
    Host.hostId,
    Host.HostName,
    oldIpAddress,
    newIpAddress,
    changeDate
FROM HostIpAddressHistory
JOIN Host on Host.hostId = HostIpAddressHistory.hostID
ORDER BY changeDate;


-- 14.2 Visualization 1
SELECT
    Site.name AS SiteName,
    CAST(HostIpAddressHistory.changeDate AS DATE) AS ChangeDay,
    COUNT(*) AS NumberOfChanges
FROM HostIpAddressHistory
JOIN Host
    ON HostIpAddressHistory.hostId = Host.hostId
JOIN Interface
    ON Host.interfaceId = Interface.interfaceId
JOIN Device
    ON Interface.deviceId = Device.deviceId
JOIN Site
    ON Device.siteId = Site.siteId
GROUP BY
    Site.name,
    CAST(HostIpAddressHistory.changeDate AS DATE) -- Collapse multiple rows occurring  on the same day
ORDER BY
    ChangeDay,
    Site.name;


-- 14.3 Adding Synthetic Hosts to the additional subnets
---------------------------------------------------------------
-- SYNTHETIC HOST POPULATION FOR VISUALIZATION 2
-- Ensures each subnet has a unique host count:
-- Boston HQ 10.10.10.0/24 → now 6 hosts
-- Boston HQ 10.10.20.0/24 → now 3 hosts
-- Boston HQ 10.10.30.0/24 → now 1 host
-- Sydney   10.20.10.0/24 → already 5 hosts
-- Sydney   10.20.20.0/24 → now 2 hosts
---------------------------------------------------------------

---------------------------------------------------------------
-- REFRESH REQUIRED VARIABLES 
---------------------------------------------------------------
GO
DECLARE @BostonSwitchId INT = (
    SELECT deviceId FROM Device WHERE name = 'BOS-MS225-1'
);

DECLARE @SydneySwitchId INT = (
    SELECT deviceId FROM Device WHERE name = 'SYD-MS225-1'
);

DECLARE @BostonSubnet10Id INT = (
    SELECT lanSubnetId FROM LanSubnet WHERE subnetCidr = '10.10.10.0/24'
);

DECLARE @BostonSubnet20Id INT = (
    SELECT lanSubnetId FROM LanSubnet WHERE subnetCidr = '10.10.20.0/24'
);

DECLARE @BostonSubnet30Id INT = (
    SELECT lanSubnetId FROM LanSubnet WHERE subnetCidr = '10.10.30.0/24'
);

DECLARE @SydneySubnet20Id INT = (
    SELECT lanSubnetId FROM LanSubnet WHERE subnetCidr = '10.20.20.0/24'
);


---------------------------------------------------------------
-- BOSTON SUBNET 10.10.10.0/24 — ADD 1 HOST (NOW 6 HOSTS)
---------------------------------------------------------------
DECLARE @Bos10_Port6 INT = NEXT VALUE FOR Interface_seq;

INSERT INTO Interface (
    interfaceId, deviceId, lanSubnetId, internetConnectionId,
    name, interfaceType, adminState
)
VALUES (
    @Bos10_Port6, @BostonSwitchId, @BostonSubnet10Id,
    NULL, 'port10', 'LAN', 'UP'
);

INSERT INTO Host (
    hostID, interfaceId, hostName, macAddress, assetTag, ipAddress
)
VALUES (
	NEXT VALUE FOR Host_seq,
    @Bos10_Port6,
    'bos10-host-06',
    'AA-BB-CC-DD-10-06',
    'BOS10-HOST-06',
    '10.10.10.106'
);


---------------------------------------------------------------
-- BOSTON SUBNET 10.10.20.0/24 — ADD 3 HOSTS
---------------------------------------------------------------
DECLARE @Bos20_Port1 INT = NEXT VALUE FOR Interface_seq;
DECLARE @Bos20_Port2 INT = NEXT VALUE FOR Interface_seq;
DECLARE @Bos20_Port3 INT = NEXT VALUE FOR Interface_seq;

INSERT INTO Interface (
    interfaceId, deviceId, lanSubnetId, internetConnectionId,
    name, interfaceType, adminState
)
VALUES
(@Bos20_Port1, @BostonSwitchId, @BostonSubnet20Id, NULL, 'port6', 'LAN', 'UP'),
(@Bos20_Port2, @BostonSwitchId, @BostonSubnet20Id, NULL, 'port7', 'LAN', 'UP'),
(@Bos20_Port3, @BostonSwitchId, @BostonSubnet20Id, NULL, 'port8', 'LAN', 'UP');

INSERT INTO Host (hostId, interfaceId, hostName, macAddress, assetTag, ipAddress)
VALUES
(NEXT VALUE FOR Host_seq, @Bos20_Port1, 'bos20-host-01', 'AA-BB-CC-DD-20-01', 'BOS20-HOST-01', '10.10.20.101'),
(NEXT VALUE FOR Host_seq, @Bos20_Port2, 'bos20-host-02', 'AA-BB-CC-DD-20-02', 'BOS20-HOST-02', '10.10.20.102'),
(NEXT VALUE FOR Host_seq, @Bos20_Port3, 'bos20-host-03', 'AA-BB-CC-DD-20-03', 'BOS20-HOST-03', '10.10.20.103');


---------------------------------------------------------------
-- BOSTON SUBNET 10.10.30.0/24 — ADD 1 HOST
---------------------------------------------------------------
DECLARE @Bos30_Port1 INT = NEXT VALUE FOR Interface_seq;

INSERT INTO Interface (
    interfaceId, deviceId, lanSubnetId, internetConnectionId,
    name, interfaceType, adminState
)
VALUES (
    @Bos30_Port1, @BostonSwitchId, @BostonSubnet30Id,
    NULL, 'port9', 'LAN', 'UP'
);

INSERT INTO Host (
    HostId, interfaceId, hostName, macAddress, assetTag, ipAddress
)
VALUES (
    NEXT VALUE FOR Host_seq, 
	@Bos30_Port1,
    'bos30-host-01',
    'AA-BB-CC-DD-30-01',
    'BOS30-HOST-01',
    '10.10.30.101'
);


---------------------------------------------------------------
-- SYDNEY SUBNET 10.20.20.0/24 — ADD 2 HOSTS
---------------------------------------------------------------
DECLARE @Syd20_Port1 INT = NEXT VALUE FOR Interface_seq;
DECLARE @Syd20_Port2 INT = NEXT VALUE FOR Interface_seq;

INSERT INTO Interface (
    interfaceId, deviceId, lanSubnetId, internetConnectionId,
    name, interfaceType, adminState
)
VALUES
(@Syd20_Port1, @SydneySwitchId, @SydneySubnet20Id, NULL, 'port5', 'LAN', 'UP'),
(@Syd20_Port2, @SydneySwitchId, @SydneySubnet20Id, NULL, 'port6', 'LAN', 'UP');

INSERT INTO Host (hostId, interfaceId, hostName, macAddress, assetTag, ipAddress)
VALUES
(NEXT VALUE FOR Host_seq, @Syd20_Port1, 'syd20-host-01', 'AA-BB-CC-DD-20-11', 'SYD20-HOST-01', '10.20.20.101'),
(NEXT VALUE FOR Host_seq, @Syd20_Port2, 'syd20-host-02', 'AA-BB-CC-DD-20-12', 'SYD20-HOST-02', '10.20.20.102');

-- Section 14.4 Visualization 2

SELECT
    Site.name AS SiteName,
    LanSubnet.subnetCidr,
    COUNT(Host.hostId) AS hostCount
FROM LanSubnet
JOIN LanSupernet
    ON LanSubnet.lanSupernetId = LanSupernet.lanSupernetId
JOIN Site
    ON LanSupernet.siteId = Site.siteId
LEFT JOIN Interface
    ON Interface.lanSubnetId = LanSubnet.lanSubnetId
LEFT JOIN Host
    ON Host.interfaceId = Interface.interfaceId
GROUP BY
    Site.name,
    LanSubnet.subnetCidr
ORDER BY
    Site.name,
    LanSubnet.subnetCidr;