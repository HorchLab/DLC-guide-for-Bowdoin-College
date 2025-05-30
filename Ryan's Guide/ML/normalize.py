import pandas as pd
import numpy as np

INFO, ERROR, WARNING, DEBUG = "INFO", "ERROR", "WARNING", "DEBUG"
VERBOSE, DEBUG_V = False, False

def out_msg(msg, tag = None):
    if tag:
        if tag == DEBUG and not DEBUG_V: return;
        if tag == INFO and not VERBOSE: return;
        print(f"[normalize.py - {tag}] {msg}")
    else:
        print(f"[normalize.py] {msg}")

def center(df: pd.DataFrame, anchor_point: str, midpoint: bool = True,
           anchor_point_2: str | None = None):
    center_x, center_y = None, None # This to shut python up
    if not midpoint:
        center_x, center_y = df[anchor_point + '_x'], df[anchor_point+"_y"]
    else:
        assert(anchor_point_2 is not None)
        center_x, center_y = get_midpoint(df, anchor_point, anchor_point_2)

    assert(center_x is not None)
    assert(center_y is not None)

    for cols in df.columns:
        if cols.endswith('_x'):
            df[cols] = df[cols] - center_x
        elif cols.endswith('_y'):
            df[cols] = df[cols] - center_y
        else:
            pass

    return df

def normalize(df: pd.DataFrame, reference_p1: str, reference_p2: str,
              midpoint: bool = True, reference_p1_2: str | None = None):

    out_msg("Center the dataframe", INFO)
    centered_df = center(df, reference_p1, midpoint, reference_p1_2)

    normalize_distance = get_distance(centered_df, reference_p1, reference_p2, midpoint, reference_p1_2)
    if np.std(normalize_distance) > 5:
        out_msg("Standard Deviation of normalizing distance σ≥5", WARNING)

    centered_df[[col for col in df.columns if col.endswith("_y") or col.endswith("_x")]] = centered_df[[col for col in df.columns if col.endswith("_y") or col.endswith("_x")]].div(normalize_distance, axis=0)

    return centered_df

def distance(x1, y1, x2, y2):
    return np.sqrt((x1 - x2 )**2 + (y1 - y2)**2)

def get_distance(df: pd.DataFrame, part1: str, part2: str, midpoint: bool = False, part1_2: str | None = None):
    if midpoint:
        assert(part1_2 is not None)
        center_x, center_y = get_midpoint(df, part1, part1_2)
        return distance(center_x, center_y, df[part2 + '_x'], df[part2 + '_y'])

    return distance(df[part1 + '_x'], df[part1 + '_y'], df[part2 + '_x'], df[part2 + '_y'])

def midpoint(x1, y1, x2, y2):
    return (x1 + x2) / 2, (y1 + y2) / 2

def get_midpoint(df: pd.DataFrame, part1: str, part2: str):
    return midpoint(df[part1 + '_x'], df[part1 + '_y'], df[part2 + '_x'], df[part2 + '_y'])

def angle(x1, y1, x2, y2, x3, y3):
    """
    Given three points, returns the angle between the lines formed by the three points.
    The 6 parameters could be series or scalar values.
    The angle is the angle between the lines formed by the first two points and the last two points. (e.g. Angle 123 )
    The angle is in degrees.
    """
    x1, y1 = np.asarray(x1), np.asarray(y1)
    x2, y2 = np.asarray(x2), np.asarray(y2)
    x3, y3 = np.asarray(x3), np.asarray(y3)

    # Vectors formed by the points
    v1 = np.array([x1 - x2, y1 - y2])
    v2 = np.array([x3 - x2, y3 - y2])

    # Dot product of the vectors
    dot_product = np.sum(v1 * v2, axis=0)

    # Magnitudes of the vectors
    mag_v1 = np.sqrt(np.sum(v1**2, axis=0))
    mag_v2 = np.sqrt(np.sum(v2**2, axis=0))

    # Cosine of the angle
    cos_angle = dot_product / (mag_v1 * mag_v2)

    # Clip values to avoid numerical issues with arccos
    cos_angle = np.clip(cos_angle, -1, 1)

    # Angle in radians
    angle_rad = np.arccos(cos_angle)

    # Convert to degrees
    angle_deg = np.degrees(angle_rad)

    return angle_deg

def get_angle(df: pd.DataFrame, part1: str, part2: str, part3: str):
    return angle(df[part1 + '_x'], df[part1 + '_y'], df[part2 + '_x'], df[part2 + '_y'], df[part3 + '_x'], df[part3 + '_y'])

def get_angle_from_perp(df: pd.DataFrame, anchor_part: str, measure_part: str):
    """
    Given an anchor part and a measure part, returns the angle between the line formed by the anchor part and the vertical line.
    The angle is in degrees. Make the angle negative when the measure part is to the left of the anchor part.
    """
    # Vertical line is formed by the anchor part and a point directly above the anchor part
    x2 = df[anchor_part + '_x']
    y2 = df[anchor_part + '_y']
    x1 = x2
    y1 = y2 + 1

    # The measure part is the third point
    x3 = df[measure_part + '_x']
    y3 = df[measure_part + '_y']

    raw_angle = angle(x1, y1, x2, y2, x3, y3)

    # Determine if the angle is to the left or right of the vertical line
    # If the angle is to the left, make it negative
    left_of_vertical = x3 < x2
    raw_angle[left_of_vertical] = -1 * raw_angle[left_of_vertical]

    return raw_angle
