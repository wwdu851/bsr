import json
import os

def to_minutes(t):
    if not t: return None
    try:
        h, m = map(int, t.split(':'))
        return h * 60 + m
    except:
        return None

def validate():
    stations_path = "/Users/William/git/bsr/Resources/stations.json"
    raw_data_dir = "/Users/William/git/bsr/rawData"
    
    if not os.path.exists(stations_path):
        print(f"Error: {stations_path} not found")
        return
    
    if not os.path.exists(raw_data_dir):
        print(f"Error: {raw_data_dir} not found")
        return
    
    with open(stations_path, 'r', encoding='utf-8') as f:
        stations_data = json.load(f)
    
    station_map = {s['id']: s for s in stations_data}
    
    all_valid = True
    
    for filename in sorted(os.listdir(raw_data_dir)):
        if not filename.endswith('.json'): continue
        
        filepath = os.path.join(raw_data_dir, filename)
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                train = json.load(f)
        except Exception as e:
            print(f"Error reading {filename}: {e}")
            all_valid = False
            continue
        
        train_id = train.get('id', filename)
        train_line = train.get('line')
        schedule = train.get('schedule', [])
        
        if not schedule:
            print(f"{train_id}: Empty schedule")
            all_valid = False
            continue
            
        for i, stop in enumerate(schedule):
            sid = stop.get('station_id')
            arr = stop.get('arrival_time')
            dep = stop.get('departure_time')
            
            # Rule 5: Station existence and line matching
            if sid not in station_map:
                print(f"{train_id}: Station {sid} not found in stations.json")
                all_valid = False
            else:
                if train_line not in station_map[sid].get('lines', []):
                    print(f"{train_id}: Station {sid} is not on line {train_line}")
                    all_valid = False
            
            arr_min = to_minutes(arr)
            dep_min = to_minutes(dep)
            
            # Rule checks
            if i == 0:
                # Rule 2: Departure station
                if arr is not None:
                    print(f"{train_id}: Departure station {sid} should have null arrival_time")
                    all_valid = False
                if dep is None:
                    print(f"{train_id}: Departure station {sid} should have NOT NULL departure_time")
                    all_valid = False
            elif i == len(schedule) - 1:
                # Rule 3: Arrival station
                if dep is not None:
                    print(f"{train_id}: Arrival station {sid} should have null departure_time")
                    all_valid = False
                if arr is None:
                    print(f"{train_id}: Arrival station {sid} should have NOT NULL arrival_time")
                    all_valid = False
            else:
                # Rule 1: Middle station
                if arr is None or dep is None:
                    print(f"{train_id}: Middle station {sid} should have NOT NULL arrival and departure times")
                    all_valid = False
                elif arr_min is not None and dep_min is not None:
                    if arr_min >= dep_min:
                        print(f"{train_id}: Station {sid} arrival time {arr} must be earlier than departure time {dep}")
                        all_valid = False
            
            # Rule 4: Sequence checks
            if i > 0:
                prev_stop = schedule[i-1]
                prev_dep_min = to_minutes(prev_stop.get('departure_time'))
                if arr_min is not None and prev_dep_min is not None:
                    if arr_min <= prev_dep_min:
                        print(f"{train_id}: Station {sid} arrival {arr} must be later than previous station departure {prev_stop.get('departure_time')}")
                        all_valid = False
    
    if all_valid:
        print("All JSON files are valid.")

if __name__ == "__main__":
    validate()
