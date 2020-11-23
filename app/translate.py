from googletrans import Translator


def translate(text, src, dest):
    """
    result = translator.translate(text, src, dest)
    src: source language
    dest: destination language

    result = {
        src, dest, origin, text, pronunciation
    }
    """
    translator = Translator()
    if src is None:
        src = 'auto'
    result = translator.translate(text=text, src=src, dest=dest)
    return result.text
