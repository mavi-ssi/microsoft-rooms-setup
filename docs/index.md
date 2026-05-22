# Microsoft Teams & Outlook Room Finder Setup Guide

This guide details the complete process for provisioning and configuring **5 physical conference rooms** within Microsoft 365. Following these steps ensures rooms are discoverable via the Room Finder in MS Teams and Outlook, double-bookings are strictly blocked on a first-come, first-served basis, and full calendar transparency (who booked what) is maintained to prevent administrative abuse.

---

## 📋 High-Level Implementation Overview

| Phase | Task | Interface | Target Objective |
| :--- | :--- | :--- | :--- |
| **Phase 1** | Room Mailbox Provisioning | Exchange Admin Center (GUI) | Create physical room identities and baseline capacities. |
| **Phase 2** | Booking & Anti-Abuse Policies | Exchange Admin Center (GUI) | Enforce booking durations, windows, and restrictions. |
| **Phase 3** | Transparency & Room Finder Sync | Exchange Online PowerShell | Prevent details-stripping and build Room Finder building filters. |
| **Phase 4** | Global Replication Window | Automated System Background | Wait for Microsoft's worldwide directory sync cycle (24-48 hours). |

---

## Phase 1: Create the Room Resources (Exchange GUI)

Your IT admin will handle the initial raw provisioning using a web browser inside the **Exchange Admin Center**.

1. Log in to the [Exchange Admin Center](https://admin.exchange.microsoft.com).
2. On the left navigation sidebar, choose **Recipients** $\rightarrow$ **Resources**.
3. Click the **`+ Add a room resource`** button at the top of the interface.
4. **Basic Setup Configuration:**
    * **Name:** Input a recognizable, clean string (e.g., `Conference Room 1`).
    * **Email:** Assign its unique company routing address (e.g., `conf_room1@ssiph.com`).
    * Click **Next**.
5. **Capacity & Location Properties:**
    * **Capacity:** Enter the exact physical safety occupant limit (e.g., `20`).
    * **Location:** Enter the structural floor or physical room designation (e.g., `Floor 7`).
    * Click **Next**.
6. Move directly past the default booking settings for now by clicking **Next**.
7. Review your parameters on the final summary pane and click **Create**.
8. **Repeat** this exact sequence for all 5 conference rooms.

---

## Phase 2: Configure Anti-Abuse Controls (Exchange GUI)

To prevent users from hoarding physical office space or camping out in rooms for entire days, configure hard operational boundaries visually for each room.

1. While still on the **Recipients** $\rightarrow$ **Resources** screen, click on your newly created room (e.g., `Conference Room 1`). A properties contextual panel will slide out from the right side of the page.
2. Click on the **Settings** tab at the top of that sliding panel.
3. Locate the **Booking choices** section and adjust the following settings as needed:
    * **Booking window (days):** Specifies maximum allowable days for advanced booking.
    * **Maximum duration (hours):** Specifies maximum allowable hours for a booking.
    * **Allow repeating meetings:** Specifies whether reocurring bookings are allowed.
4. Click **Save** at the bottom of the panel.
5. **Repeat** this configuration checklist for the remaining 4 rooms.

---

## Phase 3: Visibility & Room Finder Integration (PowerShell)

!!! warning "Why PowerShell is Mandatory Here"
    Microsoft prioritizes privacy defaults and advanced structural distribution properties by routing them strictly through core API layers. The specific controls needed to prevent the room from stripping meeting details (`DeleteSubject`, `DeleteComments`) and grouping rooms into a geographic list **do not exist anywhere in the graphical user interface.**

### 1. Connect to Exchange Online
Your IT Admin must run the standard PowerShell terminal application from their local machine as an **Administrator** and run the following commands to initialize the remote bridge to your cloud infrastructure:

```powershell
# Install the official Microsoft Exchange Management module from the cloud gallery
Install-Module -Name ExchangeOnlineManagement -Force

# Initiate the secure authentication handshake tunnel to your organization
Connect-ExchangeOnline
```
*Note: A modern Microsoft 365 interactive browser dialog box will display. The admin must log in with their global administrative credentials and pass the required Multi-Factor Authentication (MFA) challenge.*

### 2. Run the Unified Setup Script
Once authenticated, copy, paste, and run the comprehensive script block below to configure advanced calendar visibility rules, initialize the room finder distribution block, and tag filtering metadata:

```powershell
# 1. DEFINE TARGET ROOM MATRICES
$Rooms = @(
    "conf_room1@ssiph.com", 
    "conf_room2@ssiph.com", 
    "conf_room3@ssiph.com", 
    "conf_room4@ssiph.com", 
    "conf_room5@ssiph.com"
)

# 2. ENFORCE DATA TRANSPARENCY & PREVENT GHOST-BOOKING ABUSE
# Sets automated processing to act as a strict gatekeeper. Overlapping requests are auto-rejected.
# Setting DeleteSubject to $false preserves the text entry so colleagues can audit who is using the room and why.
foreach ($Room in $Rooms) {
    Set-CalendarProcessing -Identity $Room `
        -AutomatedProcessing AutoAccept `
        -DeleteSubject $false `
        -DeleteComments $false `
        -AddOrganizerToSubject $false
}

# 3. INITIALIZE ROOM LIST CONTAINER FOR TEAMS DISCOVERY
# Room Finder completely ignores separate mailboxes; it queries distribution chains flagged as a "-RoomList".
New-DistributionGroup -Name "SSI Main Building" -RoomList

# 4. ASSOCIATE INDIVIDUAL ROOM MAILBOXES TO THE CONTAINER LIST
foreach ($Room in $Rooms) {
    Add-DistributionGroupMember -Identity "SSI Main Building" -Member $Room
}

# 5. ATTACH FILTER METADATA FOR TEAMS ROOM FINDER SIDE-PANEL
# This maps the physical structural variables so users can filter by available hardware features.
foreach ($Room in $Rooms) {
    Set-Place -Identity $Room$ -Building "SSI Main Building" -Floor 7 -Features "Audio, Video, Display"
}

Write-Host "Configuration script successfully executed across all resource nodes!" -ForegroundColor Green
```

---

## Phase 4: The Cloud Synchronization Window

Once Phase 3 outputs a successful execution status, the server-side configuration changes are fully locked into your tenant database. However, **they will not appear inside your Microsoft Teams application instantly.**

Microsoft 365 global servers handle directory sync intervals across distributed data centers worldwide on a rolling queue cycle. 

* **The Waiting Period:** Expect a **24 to 48-hour replication timeline** before the newly constructed building list and internal metadata filter strings compile down into your local desktop Teams app.
* **Testing Room Discovery:**
    1. Close and re-open **MS Teams**. Navigate to the **Calendar** view tab on the left margin.
    2. Click **New Meeting** in the top right quadrant.
    3. Click into the **Add a room or location** text entry boundary.
    4. Click **Browse with Room Finder** (or locate the native right-side popout layout).
    5. Under the **Building** selection dropdown, you will now see **"SSI Main Building"** populated. Select it to instantly view all 5 rooms, their real-time visual scheduling grid, occupant capability counts, and available hardware filters.

---

## 🔒 Post-Implementation Operational Guarantees

Once active, the native Exchange architecture handles security and policy compliance automatically without any ongoing manual admin maintenance:

* **Strict First-Come, First-Served Enforcement:** If User A books a room for 1:00 PM, and User B sends a booking request for an overlapping window (even by a single minute), the Exchange server evaluates the conflict within milliseconds and drops a hard **"Declined"** message back to User B. The overlapping entry is blocked entirely from writing to the room's calendar grid.
* **Absolute Accountability & Anti-Tamper Isolation:** By default, only the original meeting organizer and Global Admins can alter or delete a room calendar allocation. Other corporate accounts cannot edit or overwrite another colleague's booking.
* **Granular Forensic Audit Tracking:** If a room is consistently ghost-booked (reserved but left empty), your IT admin can track down the abuse history without any complex scripts. They can simply navigate to the **Microsoft Purview Compliance Portal** (`compliance.microsoft.com`), open the **Audit** utility, filter for activity commands like `Updated calendar item` or `Cancelled calendar item`, and input the room email address to generate an exportable Excel CSV sheet detailing the precise account names, timestamps, and target machines involved.