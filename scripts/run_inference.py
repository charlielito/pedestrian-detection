import cv2
import tensorflow as tf
import os


def get_detections(model, image, min_score):
    output = model(dict(inputs=[image]))

    detections = []
    for box, score in zip(output["detection_boxes"][0], output["detection_scores"][0]):
        if score > min_score:
            detections.append(dict(box=box, score=score))

    return detections


def draw_boxes(image, detections):
    h, w = image.shape[:2]
    for detection in detections:
        y, x, y2, x2 = detection["box"]
        cv2.rectangle(
            image, (int(x * w), int(y * h)), (int(x2 * w), int(y2 * h)), (0, 0, 255), 2
        )


def run_inference_video(source_path, model, min_score):
    vs = cv2.VideoCapture(source_path)

    while True:
        (grabbed, frame) = vs.read()

        if not grabbed:
            break

        detections = get_detections(model, frame, min_score)
        draw_boxes(frame, detections)

        cv2.imshow("Video", frame)
        if cv2.waitKey(1) & 0xFF == ord("q"):
            break

    vs.release()


def run_inference_images(images_list, model, min_score):

    for image_path in images_list:
        frame = cv2.imread(image_path)
        if frame is None:
            print(f"Error reading image {image_path}")
            continue

        detections = get_detections(model, frame, min_score)
        draw_boxes(frame, detections)

        cv2.imshow("Video", frame)
        if cv2.waitKey(1) & 0xFF == ord("q"):
            break


if __name__ == "__main__":
    saved_model_path = "data/export_models/ssd_mobilenet_v2_pedestrian/saved_model"
    source_path = "data/TownCentreXVID.avi"
    # source_path = "test_images"
    min_score = 0.3

    model = tf.contrib.predictor.from_saved_model(saved_model_path)

    if os.path.isdir(source_path):
        images_list = map(
            lambda x: os.path.join(source_path, x), os.listdir(source_path)
        )
        run_inference_images(sorted(images_list), model, min_score)
    else:
        run_inference_video(source_path, model, min_score)
