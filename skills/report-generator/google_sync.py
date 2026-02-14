import gspread
from oauth2client.service_account import ServiceAccountCredentials
import os
import json

def update_hotel_sheets(data_list, spreadsheet_id, sheet_name="Sheet1"):
    """
    Data Sync Module for Hotel Management.
    Requires: credentials.json in ~/.openclaw/
    """
    scope = ["https://spreadsheets.google.com/feeds", "https://www.googleapis.com/auth/drive"]
    creds_path = os.path.expanduser("~/.openclaw/credentials.json")
    
    if not os.path.exists(creds_path):
        return "Error: พี่ครับ ผมยังไม่มีไฟล์ credentials.json ของ Google โปรดนำมาวางที่ ~/.openclaw/ ด้วยครับ"

    try:
        creds = ServiceAccountCredentials.from_json_keyfile_name(creds_path, scope)
        client = gspread.authorize(creds)
        sheet = client.open_by_key(spreadsheet_id).worksheet(sheet_name)
        
        # Append data: Expecting a list of values
        sheet.append_row(data_list)
        return f"✅ บันทึกข้อมูลลง Sheet '{sheet_name}' เรียบร้อยแล้วครับ"
    except Exception as e:
        return f"❌ เกิดข้อผิดพลาด: {str(e)}"

# Example logic for AI to call
if __name__ == "__main__":
    # This is a template for the AI to use via 'exec'
    pass
