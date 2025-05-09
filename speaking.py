import sounddevice as sd
from scipy.io.wavfile import write
import speech_recognition as sr
import threading
import re
from pydub.utils import mediainfo
from pydub import AudioSegment
FILENAME = "recorded_answer.wav"
SAMPLE_RATE = 44100  # Standard audio rate
DURATION = 20  # Max duration, but we'll stop early

FILLER_WORDS = ["um", "uh", "like", "you know", "so", "actually", "basically", "literally", "I mean", "right", "okay", "well"]
basic_vocab = set(["i", "you", "he", "she", "it", "we", "they", "go", "have", "do", "make", "like", "want", "need", "good", "bad", "happy", "sad", "run", "walk", "eat", "drink", "say", "tell"])


def record_audio():
    print("🎙️ Recording... Press Enter to stop.")
    recording = sd.rec(int(DURATION * SAMPLE_RATE), samplerate=SAMPLE_RATE, channels=1)
    input()  # Wait for Enter
    sd.stop()
    
    # Convert float32 to int16 PCM (required by speech_recognition)
    write(FILENAME, SAMPLE_RATE, (recording * 32767).astype("int16"))
    print("✅ Recording saved!")


def transcribe_audio():
    recognizer = sr.Recognizer()
    with sr.AudioFile(FILENAME) as source:
        audio_data = recognizer.record(source)

    try:
        text = recognizer.recognize_google(audio_data)
        print("\n📝 Transcription:\n" + text)
        return text
    except sr.UnknownValueError:
        print("❌ Could not understand your speech.")
    except sr.RequestError:
        print("❌ Could not connect to the speech recognition service.")
    
    return None  # important: ensure function returns something



def count_filler_words(text):
    text_lower = text.lower()
    filler_count = {}
    total_filler = 0

    for word in FILLER_WORDS:
        count = len(re.findall(r'\b' + re.escape(word) + r'\b', text_lower))
        filler_count[word] = count
        total_filler += count
    
    return filler_count, total_filler


def check_basic_vocab(text, basic_vocab):
    words = re.findall(r'\b\w+\b', text.lower())
    total_words = len(words)
    basic_words = [word for word in words if word in basic_vocab]
    percent_basic = (len(basic_words) / total_words) * 100 if total_words > 0 else 0
    return len(basic_words), total_words, percent_basic


def get_audio_duration(file_path):
    audio = AudioSegment.from_file(file_path)
    duration_sec = len(audio) / 1000  # pydub gives duration in ms
    return duration_sec


def calculate_speaking_rate(transcript, duration_sec):
    words = re.findall(r'\b\w+\b', transcript)
    total_words = len(words)
    wpm = (total_words / duration_sec) * 60 if duration_sec > 0 else 0
    return total_words, wpm


def main():
    print("💬 IELTS Question: Describe your favorite hobby and explain why you enjoy it.\n")
    record_audio()
    transcript=transcribe_audio()

    # Filler words
    filler_data, total_fillers = count_filler_words(transcript)
    print("Filler Words:", filler_data)
    print("Total Filler Words:", total_fillers)

    # Basic vocab
    basic_count, total_words, basic_percent = check_basic_vocab(transcript, basic_vocab)
    print(f"Basic Words: {basic_count}/{total_words} ({basic_percent:.2f}%)")

    file_path = r"C:\Users\acer nitro\OneDrive\Desktop\Data_science\sqlhomeworks\recorded_answer.wav"
    # Duration
    duration = get_audio_duration(file_path)
    print(f"Audio Duration: {duration:.2f} seconds")

    # Words per minute
    total_words, wpm = calculate_speaking_rate(transcript, duration)
    print(f"Total Words: {total_words}")
    print(f"Speaking Rate: {wpm:.2f} WPM")

if __name__ == "__main__":
    main() 