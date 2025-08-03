# Project 5: Implementing Azure Monitor for Basic VM Health & Alerts

## Real-World Problem Scenario

An IT administrator is responsible for a set of critical Azure Virtual Machines (VMs) hosting essential business applications. The administrator needs a system to proactively monitor the health and performance of these VMs and receive immediate notifications when potential issues arise, such as sustained high CPU utilization or critically low disk space.

## Why This Matters & Our Architectural Approach

### Problem

Reacting to system failures or performance degradation only after they impact users leads to costly downtime, service disruptions, and negative business consequences. Manually checking the health metrics of individual servers is inefficient, especially in environments with multiple VMs, and is highly prone to human error, making proactive intervention nearly impossible.

### Why This Way

Azure Monitor provides a comprehensive solution for collecting, analyzing, and acting on telemetry data from Azure resources, including VMs. It gathers metrics (numerical values representing resource performance) and logs (detailed event records) to provide deep insights into system behavior.

By configuring alert rules based on these metrics, Azure Monitor can automatically detect predefined conditions (e.g., CPU exceeding a threshold) and trigger actions. Action Groups, a component of Azure Monitor, define the actions to be taken when an alert fires, such as sending email notifications, SMS messages, or triggering automated runbooks.

This proactive approach to monitoring directly aligns with the **Operational Excellence** pillar of the **Well-Architected Framework**, enabling rapid issue detection and automated responses. This moves the operational model from reactive troubleshooting to proactive management, which is crucial for maintaining system reliability and performance in a cloud environment.

## Azure Services Involved

- Azure Monitor  
- Log Analytics *(optional, for deeper insights and querying logs)*  
- Action Groups

# Step-by-Step Guide: Implementing Azure Monitoring for a Windows VM

## 1. Deploy a Windows VM

**Estimated Time**: 15–30 minutes  
**Prerequisites**: An Azure subscription.

This step refers to **Project 2** for detailed VM deployment. Below are the general steps for deploying a Windows VM in Azure.

### Steps:

#### Sign in to the Azure Portal
- Navigate to [https://portal.azure.com/](https://portal.azure.com/) and sign in using your Azure credentials.

#### Create a Resource Group (Optional but Recommended)
- Search for **Resource groups** in the Azure portal.
- Click **+ Create**.
- Provide:
  - **Resource group name** (e.g., `myVMResourceGroup`)
  - **Region** (e.g., `East US`)
- Click **Review + create** and then **Create**.

#### Create a Virtual Machine
- Search for **Virtual machines** and select it.
- Click **+ Create** > **Azure virtual machine**.

##### Basics Tab:
- **Subscription**: Choose your Azure subscription.
- **Resource group**: Select the group created above.
- **VM name**: e.g., `myWindowsVM`
- **Region**: Same as your resource group.
- **Availability options**: Leave as default.
- **Security type**: Leave as default.
- **Image**: Choose `Windows Server 2019 Datacenter - Gen2`.
- **Size**: Select `Standard DS1_v2` or another based on your needs.
- **Username / Password**: Set secure credentials.
- **Inbound port rules**:  
  - **Public inbound ports**: Allow selected ports  
  - **Select inbound ports**: Check **RDP (3389)**

Click **Next: Disks >**

##### Disks Tab:
- **OS disk type**: Choose based on performance or cost (e.g., Standard HDD).
- Leave other settings as default.
- Click **Next: Networking >**

##### Networking Tab:
- Use default values or select existing VNet, subnet, and public IP.
- **NIC network security group**: Choose **Basic**.
- Click **Next: Management >**

##### Management Tab:
- **Boot diagnostics**: On
- **OS guest diagnostics**: On
- **Managed identity / Auto-shutdown / Backup**: Off
- Click **Next: Monitoring >**

##### Monitoring Tab:
- **Azure Monitor Agent**: On
- Click **Next: Advanced >**

##### Advanced / Tags / Review + create Tabs:
- Leave **Advanced** and **Tags** as default (tags optional).
- Review settings and click **Create**.

#### Verify Deployment
- Once completed, click **Go to resource** to open the VM overview page.

---

## 2. Enable Monitoring for VM

**Estimated Time**: 5–10 minutes

Azure VMs have basic monitoring by default. For deeper insights, install the **Azure Monitor Agent (AMA)**.

### Steps:

#### Navigate to Your VM
- In the Azure Portal, go to **Virtual Machines** and select your Windows VM.

#### Check AMA Status
- Under **Monitoring**, click **Insights** or **Monitoring settings**.
  - If you see **Configure Azure Monitor Agent**, it's not yet enabled.
  - If data is shown, AMA is already enabled.

#### Install/Enable Azure Monitor Agent
- If not enabled, click **Enable** or **Configure** in the Monitoring section.
- Follow the prompts to:
  - Install AMA extension
  - Create or link a **Data Collection Rule (DCR)**

**Alternative method**:
- Go to **Extensions + applications** under **Settings**.
- Click **+ Add**, search for **Azure Monitor Agent**, install it.
- After installation, associate a DCR.

---

## 3. Explore VM Metrics

**Estimated Time**: 5–10 minutes

Once AMA is enabled, you can view detailed guest-level metrics.

### Steps:

#### Navigate to Metrics
- Go to your VM's **Monitoring > Metrics** section.

#### Explore Available Metrics
- **Scope**: Ensure your VM is selected.
- **Metric Namespace**: Choose from:
  - **Virtual Machine Host**: platform metrics like CPU, Disk, Network.
  - **Azure Monitor Agent**: guest metrics like Memory, Logical Disk.

#### Common Metrics to Explore:
- `Percentage CPU`
- `Disk Read Operations/s`
- `Disk Write Operations/s`
- `Network In Total`
- `Network Out Total`
- `Logical Disk Bytes/sec` (if AMA enabled)
- `Memory Available Bytes` (if AMA enabled)

#### Customize the View:
- Choose aggregation: Avg, Max, Min, etc.
- Adjust **Time range** (e.g., Last 30 minutes)
- Add multiple metrics to compare on the same chart.

---

## 4. Create an Alert Rule

**Estimated Time**: 10–15 minutes

This alert will notify you when a metric (e.g., CPU usage) exceeds a threshold.

### Steps:

#### Navigate to Alerts
- From your VM page, go to **Monitoring > Alerts**.
- Click **+ Create alert rule**

#### Define the Condition
- **Scope**: Your VM should be pre-selected.
- **Condition**: Click **Add condition**
  - **Signal name**: Search for and select `Percentage CPU`
  - **Threshold**:  
    - Operator: Greater than  
    - Value: `90`  
    - Aggregation: Average  
    - Period: `5 minutes`  
    - Frequency: `1 minute`
- Click **Done**

#### Define the Action Group
- Click **Create action group**
  - **Name**: e.g., `HighCPUAlertActionGroup`
  - **Display name**: e.g., `High CPU Alert`
  - **Resource group**: Choose existing
  - Go to **Next: Notifications >**
    - **Notification type**: Email
    - **Name**: e.g., `EmailAdmin`
    - Enter email address
  - **Review + create** > **Create**

#### Final Alert Details
- **Alert rule name**: e.g., `High CPU Usage Alert for myWindowsVM`
- **Description**: e.g., `Triggers when CPU usage exceeds 90% over 5 mins.`
- **Severity**: Select (e.g., Sev 2 - Critical)
- Ensure **Enable upon creation** is checked.
- Click **Create alert rule**

---

## 5. Test Alert

To test the alert, simulate a high CPU load on your VM using a PowerShell script.

**Estimated Time**: 5–15 minutes

---

### Steps:

#### Connect to Your Windows VM

1. In the Azure Portal, go to your VM's **Overview** page.
2. Click **Connect** and select **RDP**.
3. Download the RDP file and open it.
4. Enter the administrator username and password created during VM setup.

---

#### Open PowerShell on the VM

1. After connecting via RDP, click the **Start** button.
2. Search for **PowerShell** and open **Windows PowerShell** or **Windows PowerShell ISE**.

---

### Run PowerShell Script to Increase CPU Load

> ⚠️ **Important:** This script will consume significant CPU resources. Monitor the VM and stop the script after the alert triggers or testing is complete. The basic script targets a single CPU core. To stress multiple cores, run it in multiple PowerShell windows or use a multi-threaded variant.

---

#### **Option 1: Basic CPU Load (Single Core)**

Copy and paste the following script into PowerShell and press **Enter**:

```powershell
while ($true) { $null = 1 + 1 }
```
To Stop the Script
Press `Ctrl + C` in the PowerShell window.

For **multi-core stress testing**, run this in **multiple PowerShell windows**.

---

#### Option 2: Controlled CPU Load (Adjustable Target)

This function simulates a target CPU load for a specified duration:

```powershell
function Start-CPUStress {
    param (
        [int]$TargetCpu = 80,
        [int]$DurationSeconds = 300 # 5 minutes
    )

    Write-Host "Starting CPU stress to target $TargetCpu% for $DurationSeconds seconds..."

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $endTime = $sw.Elapsed.TotalSeconds + $DurationSeconds

    while ($sw.Elapsed.TotalSeconds -lt $endTime) {
        $startTime = Get-Date

        for ($i = 0; $i -lt 10000000; $i++) {
            $null = [Math]::Sqrt($i) * [Math]::Sin($i)
        }

        $workDuration = (Get-Date) - $startTime
        $sleepDuration = [System.TimeSpan]::FromMilliseconds(
            ($workDuration.TotalMilliseconds * (100 - $TargetCpu) / $TargetCpu)
        )

        if ($sleepDuration.TotalMilliseconds -gt 0) {
            Start-Sleep -Milliseconds $sleepDuration.TotalMilliseconds
        }
    }

    Write-Host "CPU stress finished."
}

```

### To Run the Function (example: 85% CPU for 10 minutes)

```powershell
Start-CPUStress -TargetCpu 85 -DurationSeconds 600
```

💡 **Tip:** For reliable alert testing, running the basic `while ($true)` loop in multiple PowerShell windows is often more effective, especially on multi-core VMs.

---

### Monitor CPU Usage in Azure Portal

While the script is running:

1. Go to the **VM's Metrics** section in the Azure Portal.
2. Select **Percentage CPU** as the metric.
3. Set **Aggregation** to **Average**.
4. Set **Time Range** to a recent period (e.g., **Last 30 minutes**).
5. You should see a CPU spike that remains above your alert threshold (e.g., **90%**).

---

### Observe Alert Notification

Once the average CPU usage exceeds the defined threshold for the specified period (e.g., **5 minutes**):

- Your alert rule should trigger.
- Check the inbox of the email address associated with your **Action Group**.
- The alert notification will include details about the metric that triggered the alert.

---

### Stop CPU Load

1. Return to the **RDP session** on your VM.
2. In each PowerShell window running `while ($true)`, press `Ctrl + C`.
3. Confirm that CPU usage drops to normal using **Task Manager** or **Azure Metrics**.

---

### ✅ Expected End-User/Customer Benefits

- **Proactive Issue Detection:** Identifies potential problems before they cause outages.
- **Reduced Downtime:** Alerts trigger early, allowing for quick remediation.
- **Improved Reliability:** Monitoring supports consistent application performance.
- **Automated Notifications:** Key IT personnel are promptly informed of issues.

