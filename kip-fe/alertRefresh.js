async function refreshNotification() {
    const notification = useNotifications();
    await notification.setMyNotification();
}

export default refreshNotification;
